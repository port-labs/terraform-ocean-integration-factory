#!/usr/bin/env python3
from typing import Optional, Dict, Any

from google.cloud.asset_v1 import AssetServiceClient
from google.cloud.resourcemanager_v3 import TagBindingsClient, TagValuesClient
from google.api_core.exceptions import NotFound, GoogleAPICallError, RetryError

from utils import parse_protobuf_message, logger, parse_results
from errors import EmptyParentError, ConflictingParentError
import sys
import json


class AssetFeedManager:
    def __init__(
        self,
        asset_client: AssetServiceClient = AssetServiceClient(),
        tag_client: TagBindingsClient = TagBindingsClient(),
        tag_value_client: TagValuesClient = TagValuesClient(),
    ):
        self.asset_client = asset_client
        self.tag_client = tag_client
        self.tag_value_client = tag_value_client

    def describe_feed(
        self,
        feed_id: str,
        tag: str,
        project: Optional[str] = None,
        organization: Optional[str] = None,
    ) -> Dict[str, Any]:
        """
        Describes a feed given its ID and scope (project or organization).
        Checks for tags on the feed to determine if it is managed by Terraform.

        Args:
            feed_id (str): The ID of the feed.
            project (Optional[str]): The project ID.
            organization (Optional[str]): The organization ID.

        Returns:
            Dict[str, Any]: A dictionary containing feed details or error information.
        """
        try:
            parent = self.parent(project, organization)
            feed_name = f"{parent}/feeds/{feed_id}"
            logger.debug(f"Constructed feed name: {feed_name}")

            feed = self.asset_client.get_feed(name=feed_name)
            results = parse_protobuf_message(feed)
            results = parse_results(results)
            logger.info(f"Feed '{feed_id}' exists.")

            # Check if the feed is tagged as managed by Terraform
            resource_name = f"//cloudresourcemanager.googleapis.com/{parent}"
            logger.info(f"resource name: {resource_name}")
            is_managed_by_terraform = self.check_tag_binding(resource_name, tag)
            results["managed_by_terraform"] = is_managed_by_terraform

            return {"exists": "true", **results}

        except NotFound:
            logger.info(f"Feed '{feed_id}' does not exist.")
            return {"exists": "false", "managed_by_terraform": "true"}

        except (GoogleAPICallError, RetryError) as api_error:
            logger.error(f"API error occurred: {api_error}")
            sys.exit(json.dumps({"error": f"API error occurred: {api_error}"}))

        except (EmptyParentError, ConflictingParentError) as client_error:
            logger.error(f"Error occurred: {client_error}")
            sys.exit(json.dumps({"error": f"{client_error}"}))

        except Exception as e:
            logger.error(f"An unexpected error occurred: {e}")
            sys.exit(json.dumps({"error": f"An unexpected error occurred. {e}"}))

    def parent(self, project: Optional[str] = None, organization: Optional[str] = None):
        if not project and not organization:
            raise EmptyParentError(
                "Either 'project' or 'organization' must be specified."
            )

        if project and organization:
            raise ConflictingParentError(
                "Specify either 'project' or 'organization', not both."
            )

        return f"projects/{project}" if project else f"organizations/{organization}"

    def check_tag_binding(self, resource_name: str, tag: str) -> bool:
        """
        Checks if a given resource has the 'managed-by=terraform' tag binding.

        Args:
            resource_name (str): The full name of the resource.

        Returns:
            str : true if the tag 'managed-by=terraform' is attached, otherwise false.
        """

        tag_bindings = self.tag_client.list_tag_bindings(parent=resource_name)
        for tag_binding in tag_bindings:
            tag_value_id = tag_binding.tag_value
            tag_value = self.tag_value_client.get_tag_value(name=tag_value_id)

            if tag_value.short_name == tag:
                logger.info(f"Resource '{resource_name}' is managed by Terraform.")
                return "true"
        logger.info(f"Resource '{resource_name}' is not managed by Terraform.")
        return "false"

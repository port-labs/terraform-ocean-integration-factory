#!/usr/bin/env python3
from typing import Optional, Dict, Any

from google.cloud.asset_v1 import AssetServiceClient
from google.api_core.exceptions import NotFound, GoogleAPICallError, RetryError

from utils import parse_protobuf_message, logger, parse_results
from errors import EmptyParentError, ConflictingParentError


class AssetFeed:
    def __init__(self, client: AssetServiceClient =  AssetServiceClient()):
        self.client = client

    def describe_feed(
        self,
        feed_id: str,
        project: Optional[str] = None,
        organization: Optional[str] = None,
    ) -> Dict[str, Any]:
        """
        Describes a feed given its ID and scope (project or organization).

        Args:
            feed_id (str): The ID of the feed.
            project (Optional[str]): The project ID.
            organization (Optional[str]): The organization ID.

        Returns:
            Dict[str, Any]: A dictionary containing feed details or error information.
        """
        parent = self.parent(project, organization)
        feed_name = f"{parent}/feeds/{feed_id}"
        logger.debug(f"Constructed feed name: {feed_name}")
        try:
            feed = self.client.get_feed(name=feed_name)
            results = parse_protobuf_message(feed)
            
            results = parse_results(results)
            logger.info(f"Feed '{feed_id}' exists.")
            
            return {
                "exists": "true",
                **results
            }
        except NotFound:
            logger.info(f"Feed '{feed_id}' does not exist.")
            return {"exists": "false"}
        except (GoogleAPICallError, RetryError) as api_error:
            raise api_error
        except Exception as e:
            raise Exception("An unexpected error occurred: {e}")

    def parent(self, project: Optional[str] = None, organization: Optional[str] = None):
        if not project and not organization:
            raise EmptyParentError("Either 'project' or 'organization' must be specified.")

        if project and organization:
            raise ConflictingParentError("Specify either 'project' or 'organization', not both.")

        if project:
            parent = f"projects/{project}"
        else:
            parent = f"organizations/{organization}"
        
        return parent

from typing import Dict, Any, Literal

from google.cloud.asset_v1 import AssetServiceClient
from google.cloud.resourcemanager_v3 import TagBindingsClient, TagValuesClient, TagKeysClient, ListTagKeysRequest

from utils import parse_protobuf_message, logger, parse_results
from errors import EmptyParentError, ConflictingParentError
from google.api_core.exceptions import NotFound


class GoogleCloudResource:

    def __init__(self, container: Literal["projects", "organizations"], container_id: str):
        self.container = container
        self.container_id = container_id
        self.parent_id = self.parent(container_id)
        self.client = self.default_client()

    def parent(self, container_id: str) -> str:
        return f"{self.container}/{container_id}"

    def default_client(self) -> Any:
        raise NotImplementedError("Subclasses must implement this method to return a default client.")
    

class AssetFeed(GoogleCloudResource):
    def default_client(self) -> AssetServiceClient:
        return AssetServiceClient()

    def get_asset_feed(
        self,
        feed_id: str,
    ) -> Dict[str, Any]:
        """
        Describes a feed given its ID and scope (project or organization).
        Checks for tags on the feed to determine if it is managed by Terraform.

        Args:
            feed_id (str): The ID of the feed.

        Returns:
            Dict[str, Any]: A dictionary containing feed details.
        """
        try:
            feed_name = f"{self.parent_id}/feeds/{feed_id}"
            feed = self.client.get_feed(name=feed_name)
            results = parse_protobuf_message(feed)
            results = parse_results(results)
            return results
        except NotFound:
            return {}


class Tags(GoogleCloudResource):
    def default_client(self) -> AssetServiceClient:
        return {
            "tag_binding_client": TagBindingsClient(),
            "tag_values_client": TagValuesClient()
        }
    
    def check_tag_binding(self, resource: str, tag: str) -> bool:
        """
        Checks if a given resource has the specified tag binding.

        Args:
            resource_name (str): The full name of the resource.
            tag (str): The tag to check for.

        Returns:
            bool: True if the tag is attached to the resource, False otherwise.
        """
        parent = f"//{resource}/{self.parent_id}"
        tag_bindings = self.client['tag_binding_client'].list_tag_bindings(parent=parent)
        for tag_binding in tag_bindings:
            tag_value_id = tag_binding.tag_value
            tag_value = self.client['tag_values_client'].get_tag_value(name=tag_value_id)
            if tag_value.short_name == tag:
                return True
        return False
    

    def check_tag_key_exists(self, tag_key: str = "managed-by") -> bool:
        """
        Check whether a specific tag key exists for a given Google Cloud resource.

        Args:
            resource_id (str): The ID of the Google Cloud resource (e.g., a project, folder, or organization).
            tag_key (str): The key of the tag to check.

        Returns:
            bool: True if the tag key exists, False otherwise.
        """
        try:
            tag_keys_client = TagKeysClient()

            request = ListTagKeysRequest(parent="organizations/182656965936")
            response = tag_keys_client.list_tag_keys(request=request)

            for tag_key_resource in response:
                print(tag_key_resource.short_name == "managed-by")
                if str(tag_key_resource.short_name) == tag_key:
                    return True
            return False

        except NotFound:
            return False
import json
import sys
from utils import logger, read_input
from errors import EmptyParentError, ConflictingParentError
from client import AssetFeed, Tags
from google.api_core.exceptions import GoogleAPICallError, RetryError


def main():
    input_args = read_input()
    feed_id = input_args.get("feed_id")
    project = input_args.get("project")
    organization = input_args.get("organization")
    tag_value = input_args.get("tag")
    tag_resource = input_args.get("tag_resource")

    try:
        if project and organization:
            raise ConflictingParentError(
                "Specify either 'project' or 'organization', not both."
            )

        container = "projects" if project else "organizations"
        container_id = project or organization

        if not container_id:
            raise EmptyParentError(
                "Either 'project' or 'organization' must be specified."
            )

        if not feed_id:
            logger.error("Missing 'feed_id' in input.")
            print(json.dumps({"error": "Missing 'feed_id' in input."}))
            sys.exit(1)

        asset_feed =  AssetFeed(container=container, container_id=container_id)
        asset_feed_info = asset_feed.get_asset_feed(feed_id)
        if not asset_feed_info:
            response = {"exists": "false", "managed_by_terraform": "true"}
            print(json.dumps(response))
            return
        
        tag = Tags(container=container, container_id=container_id)
        is_managed_by_terraform = tag.check_tag_binding(tag_resource, tag_value)
        asset_feed_info["managed_by_terraform"] = str(is_managed_by_terraform).lower()
        response = {"exists": "true", **asset_feed_info}
        print(json.dumps(response))
        return
    
    except (GoogleAPICallError, RetryError) as api_error:
        logger.error(f"API error occurred: {api_error}")
        sys.exit(1)

    except (EmptyParentError, ConflictingParentError) as client_error:
        logger.error(f"Error occurred: {client_error}") 
        sys.exit(1)

if __name__ == "__main__":
    main()
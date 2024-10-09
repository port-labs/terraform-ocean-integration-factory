from utils import logger, read_input
from asset_feed import AssetFeedManager
import sys
import json


def main():
    input_args = read_input()
    feed_id = input_args.get("feed_id")
    project = input_args.get("project")
    organization = input_args.get("organization")
    tag = input_args.get("tag")

    if not feed_id:
        logger.error("Missing 'feed_id' in input.")
        sys.exit(json.dumps({"error": "Missing 'feed_id' in input."}))

    asset_feed = AssetFeedManager()

    result = asset_feed.describe_feed(feed_id, tag, project, organization)
    print(json.dumps(result))


if __name__ == "__main__":
    main()

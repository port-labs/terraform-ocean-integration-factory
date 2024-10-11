import proto
from typing import Any, Dict
import json
import sys
import logging

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger(__name__)

def parse_protobuf_message(message: proto.Message) -> dict[str, Any]:
    return proto.Message.to_dict(message)

def parse_results(results: Dict[str, Any]) -> Dict[str, Any]:
    result = {
        "name": str(results['name']),
        "asset_types": str(results['asset_types']),
    }
    return result

def read_input() -> Dict[str, Any]:
    """
    Reads JSON input from stdin.

    Returns:
        Dict[str, Any]: The parsed JSON input.
    """
    try:
        input_data = sys.stdin.read()
        logger.debug(f"Input data: {input_data}")
        return json.loads(input_data)
    except json.JSONDecodeError as e:
        logger.error(f"Invalid JSON input: {e}")
        sys.exit(json.dumps({"error": "Invalid JSON input."}))
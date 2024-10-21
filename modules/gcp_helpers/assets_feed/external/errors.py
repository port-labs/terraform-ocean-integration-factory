class EmptyParentError(Exception):
    """Raised when a project or organization is not provided."""
    pass

class ConflictingParentError(Exception):
    """Raised when both project and organization are provided."""
    pass

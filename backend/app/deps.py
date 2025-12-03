"""
Dependencies and utilities for FastAPI routes.
"""
from pathlib import Path
import sys

# Ensure ml_model can be imported
PROJECT_ROOT = Path(__file__).parent.parent.parent
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))


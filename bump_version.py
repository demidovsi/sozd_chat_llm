"""
Version management script
Manages semantic versioning: MAJOR.MINOR.PATCH
"""
import json
import argparse
from datetime import datetime
import subprocess
import sys


VERSION_FILE = 'version.json'


def read_version():
    """Read current version from version.json"""
    try:
        with open(VERSION_FILE, 'r', encoding='utf-8') as f:
            data = json.load(f)
            return data['version']
    except FileNotFoundError:
        print(f"Error: {VERSION_FILE} not found")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Error: {VERSION_FILE} is not valid JSON")
        sys.exit(1)


def write_version(version):
    """Write new version to version.json"""
    data = {
        'version': version,
        'date': datetime.now().strftime('%Y-%m-%d')
    }
    with open(VERSION_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f"Version updated to {version}")


def parse_version(version_str):
    """Parse version string into (major, minor, patch)"""
    try:
        parts = version_str.split('.')
        if len(parts) != 3:
            raise ValueError("Version must have 3 parts: MAJOR.MINOR.PATCH")
        return tuple(int(p) for p in parts)
    except ValueError as e:
        print(f"Error parsing version '{version_str}': {e}")
        sys.exit(1)


def bump_patch(version_str):
    """Increment PATCH version (1.0.6 -> 1.0.7)"""
    major, minor, patch = parse_version(version_str)
    return f"{major}.{minor}.{patch + 1}"


def bump_minor(version_str):
    """Increment MINOR version and reset PATCH (1.0.6 -> 1.1.0)"""
    major, minor, patch = parse_version(version_str)
    return f"{major}.{minor + 1}.0"


def bump_major(version_str):
    """Increment MAJOR version and reset MINOR and PATCH (1.0.6 -> 2.0.0)"""
    major, minor, patch = parse_version(version_str)
    return f"{major + 1}.0.0"


def create_git_tag(version, message=None):
    """Create a git tag for the version"""
    tag_name = f"v{version}"
    try:
        # Check if tag already exists
        result = subprocess.run(
            ['git', 'tag', '-l', tag_name],
            capture_output=True,
            text=True,
            check=True
        )

        if result.stdout.strip():
            print(f"Warning: Tag {tag_name} already exists")
            return False

        # Create annotated tag
        tag_message = message or f"Release version {version}"
        subprocess.run(
            ['git', 'tag', '-a', tag_name, '-m', tag_message],
            check=True
        )
        print(f"Git tag {tag_name} created")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error creating git tag: {e}")
        return False
    except FileNotFoundError:
        print("Git not found. Skipping tag creation.")
        return False


def main():
    parser = argparse.ArgumentParser(
        description='Manage application version (MAJOR.MINOR.PATCH)',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python bump_version.py --show              # Show current version
  python bump_version.py --patch             # Bump patch: 1.0.6 -> 1.0.7
  python bump_version.py --minor             # Bump minor: 1.0.6 -> 1.1.0
  python bump_version.py --major             # Bump major: 1.0.6 -> 2.0.0
  python bump_version.py --set 1.2.3         # Set specific version
  python bump_version.py --patch --tag       # Bump patch and create git tag
  python bump_version.py --patch --tag -m "Bug fixes"  # With custom message
        """
    )

    group = parser.add_mutually_exclusive_group()
    group.add_argument('--show', action='store_true', help='Show current version')
    group.add_argument('--patch', action='store_true', help='Increment PATCH version')
    group.add_argument('--minor', action='store_true', help='Increment MINOR version')
    group.add_argument('--major', action='store_true', help='Increment MAJOR version')
    group.add_argument('--set', metavar='VERSION', help='Set specific version (e.g., 1.2.3)')

    parser.add_argument('--tag', action='store_true', help='Create git tag for the version')
    parser.add_argument('-m', '--message', help='Git tag message')

    args = parser.parse_args()

    # Default to --show if no arguments
    if not any([args.show, args.patch, args.minor, args.major, args.set]):
        args.show = True

    current_version = read_version()

    if args.show:
        print(f"Current version: {current_version}")
        return

    # Determine new version
    if args.patch:
        new_version = bump_patch(current_version)
    elif args.minor:
        new_version = bump_minor(current_version)
    elif args.major:
        new_version = bump_major(current_version)
    elif args.set:
        # Validate the version format
        parse_version(args.set)
        new_version = args.set

    print(f"Current version: {current_version}")
    print(f"New version: {new_version}")

    # Update version file
    write_version(new_version)

    # Create git tag if requested
    if args.tag:
        create_git_tag(new_version, args.message)


if __name__ == '__main__':
    main()

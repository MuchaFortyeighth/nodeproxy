import json

def convert_ast_to_legacy_ast(ast):
    """
    Convert a modern Solidity AST node to a legacyAST format.
    This script simplifies the AST structure by keeping only essential information.
    """

    def map_node(node):
        """Recursively map a single AST node to legacyAST format."""
        legacy_node = {
            "name": node.get("nodeType", ""),  # Use "nodeType" as the legacy node name
            "attributes": {},                 # Initialize attributes
            "children": []                    # Initialize children
        }

        # Map attributes: Filter keys that are relevant as attributes
        for key, value in node.items():
            if key not in ["nodeType", "nodes", "children"]:  # Exclude nested nodes
                # Simplify complex objects like `typeDescriptions`
                if isinstance(value, dict):
                    legacy_node["attributes"][key] = str(value)
                else:
                    legacy_node["attributes"][key] = value

        # Recursively map child nodes
        if "nodes" in node:
            legacy_node["children"] = [map_node(child) for child in node["nodes"]]
        elif "children" in node:
            legacy_node["children"] = [map_node(child) for child in node["children"]]

        return legacy_node

    # Start conversion from the root node
    return map_node(ast)


# Example usage
if __name__ == "__main__":
    # Replace 'modern_ast.json' with your modern AST JSON file
    with open("modern_ast.json", "r") as f:
        modern_ast = json.load(f)

    # Convert to legacyAST
    legacy_ast = convert_ast_to_legacy_ast(modern_ast)

    # Save the converted legacyAST to a file
    with open("legacy_ast.json", "w") as f:
        json.dump(legacy_ast, f, indent=4)

    print("Conversion complete. Legacy AST saved to 'legacy_ast.json'.")

import js from "eslint/js";
import globals from "globals";

export default [
    js.configs.recommended,
    {
        files: ["**/*.js", "**/*.jsx"],
        languageOptions: {
            globals: { ...globals.browser, ...globals.node },
            parserOptions: {
                ecmaFeatures: {
                    jsx: true,
                }
            }
        },
    },
]
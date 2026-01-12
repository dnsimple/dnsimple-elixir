# Releasing

This document describes the steps to release a new version of DNSimple/Elixir.

## Prerequisites

- You have commit access to the repository
- You have push access to the repository
- You have a GPG key configured for signing tags
- You have permission to publish to Hex

## Release process

1. **Determine the new version** using [Semantic Versioning](https://semver.org/)

   ```shell
   VERSION=X.Y.Z
   ```

   - **MAJOR** version for incompatible API changes
   - **MINOR** version for backwards-compatible functionality additions
   - **PATCH** version for backwards-compatible bug fixes

2. **Run tests** and confirm they pass

   ```shell
   mix test
   ```

3. **Update the version file** with the new version

   Edit `mix.exs`:

   ```elixir
   defmodule Dnsimple.Mixfile do
     use Mix.Project

     def project do
       [app: :dnsimple,
        version: "$VERSION",
   ```

4. **Run tests** again and confirm they pass

   ```shell
   mix test
   ```

5. **Update the changelog** with the new version

   Finalize the `## main` section in `CHANGELOG.md` assigning the version.

6. **Commit the new version**

   ```shell
   git commit -a -m "Release $VERSION"
   ```

7. **Push the changes**

   ```shell
   git push origin main
   ```

8. **Wait for CI to complete**

9. **Create a signed tag**

   ```shell
   git tag -a v$VERSION -s -m "Release $VERSION"
   git push origin --tags
   ```

10. **Publish to Hex**

    ```shell
    mix hex.publish
    ```

## Post-release

- Verify the new version appears on [Hex](https://hex.pm/packages/dnsimple)
- Verify the GitHub release was created
- Announce the release if necessary

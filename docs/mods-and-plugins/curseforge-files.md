# Auto-download from CurseForge

Mods and plugins can be auto-downloaded and upgraded from CurseForge by setting `CURSEFORGE_FILES` to a comma or space delimited list of [project-file references](#project-file-references). References removed from the declaration are automatically cleaned up and setting `CURSEFORGE_FILES` to an empty string removes all previously managed project-files.

A specific file can be omitted from each reference to allow for auto-selecting the newest version of the selected mod/plugin. The resolved `VERSION` and `TYPE` will be taken into consideration for selecting the appropriate file. 

!!! warning "CurseForge API key usage"

    A CurseForge API key must be allocated and set with `CF_API_KEY` [as described here](../types-and-platforms/mod-platforms/auto-curseforge.md#api-key).

## Project-file references

!!! tip

    Individual project files typically represent a version of the mod/plugin, but CurseForge refers to these items broadly as "files" rather than "versions". 

The following formats are supported in the list of project-file references:

- A project page URL, such as `https://www.curseforge.com/minecraft/mc-mods/jei`. _The newest applicable file will be automatically selected._
- A file page URL, such as `https://www.curseforge.com/minecraft/mc-mods/jei/files/4593548`
- Project slug, such as `jei`. _The newest applicable file will be automatically selected._
- Project ID, such as `238222`. _The newest applicable file will be automatically selected._
- Project slug or ID, `:`, and a file ID, such as `jei:4593548` or `238222:4593548`
- Project slug or ID, `@`, and a partial filename, such as `jei@10.2.1.1005`. This option is useful to refer to a version of the mod/plugin rather than looking up the file ID.
- An `@` followed by the **container path** to a listing file

!!! info "More about listing files"

    Each line in the listing file is processed as one of the references above; however, blank lines and comments that start with `#` are ignored.
    
    Make sure to place the listing file in a mounted directory/volume or declare an appropriate mount for it.
    
    For example, `CURSEFORGE_FILES` can be set to "@/extras/cf-mods.txt", assuming "/extras" has been added to `volumes` section, where the container file `/extras/cf-mods.txt` contains
    
    ```text
    # This comment is ignored
    jei:10.2.1.1005
    
    # This and previous blank line are ignore
    geckolib
    aquaculture
    naturalist
    ```

!!! tip "Multi-line values in Docker Compose"

    Making use of the space delimited option, compose file declarations can be organized nicely with a [multi-line string](https://yaml-multiline.info/), such as
    
    ```yaml
          CURSEFORGE_FILES: |
            geckolib
            aquaculture
            naturalist
    ```

## Dependencies

The files processing can detect if a dependency is missing from the given list, but is not able to resolve the dependencies otherwise since their metadata only gives the mod ID and not the specific file version/ID that is needed.

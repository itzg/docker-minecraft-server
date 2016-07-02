.[] |
 select(.elements | length > 1) |
  select(.elements[].elements[] | select(.class == "version" and .text == $version)) |
   .elements[].elements[] | 
    select(.class|contains("server-jar")) |
     .elements[] | select(.name="a") |
      .href

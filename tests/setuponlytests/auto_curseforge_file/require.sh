[[ -n "$CF_API_KEY" ]] || exit 1
echo "$CF_API_KEY" > cf_api_key.secret || exit 1
# how to upload the dashboards

1. When you login for the first time, [Select your tenant] is displayed. Select [Global]. You can use the prepared dashboard etc.
1. You can also select [Private] instead of [Global] in [Select your tenant] and customize configuration and dashboard etc. for each user. The following is the procedure for each user. If you select Global, you do not need to set it.
1. To import OpenSearch Dashboards' configuration files such as dashboard:
    1. Navigate to the OpenSearch Dashboards console.
    2. Click on "Stack Management" in the left pane, then choose "Saved Objects" --> "Import" --> "Import".
    3. Choose [dashboard.ndjson](dashboard.ndjson).
    4. Log out and log in again so that the imported configurations take effect.

## example dashboard upload with api
curl -X POST "http://localhost:5601/api/saved_objects/_import?overwrite=true" -H "osd-xsrf: true" -k -u {id}:{password} --form file=dashboard.ndjson

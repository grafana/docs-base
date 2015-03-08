---
title: Docs - InfluxDB
---

# InfluxDB

### InfluxDB query editor

![](influxdb_editor.png)

When you add an InfluxDB query you can specify series name (can be regex), value column and a function. Group by time can be specified or if left blank will be automatically set depending on how long the current time span is. It will translate to a InfluxDB query that looks like this:

```sql
select [[func]]([[column]]) from [[series]] where [[timeFilter]] group by time([[interval]]) order asc
```

To write the complete query yourself click the cog wheel icon to the right and select ``Raw query mode``.

## InfluxDB Filters & Templated queries

![](animated_gifs/influxdb_templated_query.gif)


Use a distinct influxdb query in the filter query input box:

```sql
select distinct(host) from app.status
```




(Optional) If you want to forward metrics and you haven't already created a Splunk Index for metrics, take the steps below to add one. You can do the same for events, although you could also use the existing, default "main" index.

1. Open the Splunk web interface and log in.
2. Select **Settings**, then select **Indexes**.
3. Select **New Index**.
4. Add a Name.
5. For the *Index Data Type*, select **Metrics** or **Events**.
6. Select **Save**.


### Set up Splunk to Monitor Data: 

1. Open the Splunk web interface and log in.
2. On the Explore Splunk Enterprise menu, select **Add Data**.
3. Select **Monitor** as the data method.
4. On the Add Data *Select Source* page, select **HTTP Event Collector**.
5. Add a Name.
6. Add a Description.
7. Select **Next**.
8. On the Add Data *Input Settings* page, select one or more of the available Splunk Indexes with the appropriate *Index Data Type*.
9. Select **Review**.
10. On the summary page, copy and save the token value. **You'll configure NGINX Controller with this value later**.
  
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-555 -->
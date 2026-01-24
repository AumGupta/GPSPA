# How to recreate the classic model in PostgreSQL

1. Open **PgAdmin4**
2. Enter your master password (we used `master`)
3. In the *Browser panel*, expand **Servers**, then expand the **PostgreSQL 14** cluster.
4. Right-click **Databases** and select **Create Database**
5. In the *Create - Database* dialog, set the **Database** name to `classic_model` and click **Save**
6. Select the newly created *classic_model* database and click the **Query Tool** button in the top of the *Browser Panel* or in the **Tools > Query Tool** menu.
7. In the Query tool use the **Open File** button to load the `classicmodel_ddl.sql` file.
8. Still in the *Query tool*, click the **Execute/Refresh button** to run all commands
9. Click the Open File button again, load the `classicmodels_insert.sql` files and execute it too.

Now, in the browser, if you expand the *classic_model* database, then expand **Schemas**, then **Public**, then **Tables**, you will see the list of tables created for the classic model.

If you right click on of them and use View/Edit Data First 100 Rows, you can confirm that the data was also inserted.

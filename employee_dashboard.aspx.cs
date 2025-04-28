using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;

namespace SmartMonitoringSystemv1._5
{
    public partial class employee_dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Cek jika session "userId" tidak ada, maka redirect ke login
            if (Session["userId"] == null)
            {
                Response.Redirect("login.aspx");
            }


            if (!IsPostBack)
            {
                LoadProducts();
                LoadWorkLogs();
                LoadDashboardData(); // Tambahkan ini

            }
        }


        private void LoadDashboardData()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
            int userId = Convert.ToInt32(Session["userId"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Finished Today
                SqlCommand cmdFinishedToday = new SqlCommand(@"
                    SELECT COUNT(*) FROM WorkLogNew 
                    WHERE UserId = @UserId AND CAST(StartTime AS DATE) = CAST(GETDATE() AS DATE) AND StatusId = 2", conn);
                cmdFinishedToday.Parameters.AddWithValue("@UserId", userId);
                int finishedToday = (int)cmdFinishedToday.ExecuteScalar();

                // Average Workmanship
                SqlCommand cmdAverageWorkmanship = new SqlCommand(@"
                    SELECT ISNULL(AVG(TotalTime), 0) 
                    FROM WorkLogNew 
                    WHERE UserId = @UserId AND StatusId = 2", conn);
                cmdAverageWorkmanship.Parameters.AddWithValue("@UserId", userId);
                int avgWorkmanshipSeconds = (int)cmdAverageWorkmanship.ExecuteScalar();

                // Total Workmanship
                SqlCommand cmdTotalWorkmanship = new SqlCommand(@"
                    SELECT COUNT(*) FROM WorkLogNew 
                    WHERE UserId = @UserId AND StatusId = 2", conn);
                cmdTotalWorkmanship.Parameters.AddWithValue("@UserId", userId);
                int totalWorkmanship = (int)cmdTotalWorkmanship.ExecuteScalar();

                conn.Close();

                // Konversi Average Workmanship dari detik ke format jam:menit:detik
                TimeSpan avgTimeSpan = TimeSpan.FromSeconds(avgWorkmanshipSeconds);
                string avgWorkmanshipFormatted = string.Format("{0:D2}:{1:D2}:{2:D2}",
                    avgTimeSpan.Hours, avgTimeSpan.Minutes, avgTimeSpan.Seconds);

                // Simpan nilai ke kontrol server atau JavaScript melalui ViewState
                ViewState["FinishedToday"] = finishedToday;
                ViewState["AverageWorkmanship"] = avgWorkmanshipFormatted;
                ViewState["TotalWorkmanship"] = totalWorkmanship;
            }
        }



        private void LoadProducts()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT productId, productName FROM products", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlProduct.DataSource = dt;
                ddlProduct.DataTextField = "productName";
                ddlProduct.DataValueField = "productId";
                ddlProduct.DataBind();

                // Tambahkan item default setelah DataBind()
                ddlProduct.Items.Insert(0, new ListItem("Select Product", "0"));

                // Pastikan dropdown kembali ke item default
                ddlProduct.SelectedIndex = 0;
            }
        }



        // Ketika product dipilih, simpan ke tabel WorkLog
        protected void ddlProduct_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlProduct.SelectedValue == "0")
            {
                // Tidak melakukan apa-apa jika item default dipilih
                return;
            }

            int productId = Convert.ToInt32(ddlProduct.SelectedValue);
            int userId = Convert.ToInt32(Session["userId"]); // Mengambil userId dari session
            DateTime startTime = DateTime.Now;
            int statusId = 1; // Status "On Progress"

            // Menghitung TotalTime sejak StartTime dalam detik
            int totalTimeInSeconds = 0; // Set initial TotalTime to 0 saat pekerjaan dimulai

            string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string insertQuery = @"
            INSERT INTO WorkLogNew (ProductId, UserId, StartTime, StatusId, TotalTime) 
            VALUES (@ProductId, @UserId, @StartTime, @StatusId, @TotalTime)";

                SqlCommand cmd = new SqlCommand(insertQuery, conn);
                cmd.Parameters.AddWithValue("@ProductId", productId);
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@StartTime", startTime);
                cmd.Parameters.AddWithValue("@StatusId", statusId);
                cmd.Parameters.AddWithValue("@TotalTime", totalTimeInSeconds);  // TotalTime diset ke 0 detik pada saat dimulai

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            // Redirect ke halaman yang sama untuk menghindari pengulangan data
            Response.Redirect(Request.RawUrl);
        }


        //DataTables
        private void LoadWorkLogs()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                int userId = Convert.ToInt32(Session["userId"]);

                // Mengambil data log pekerjaan dengan kolom TotalTime yang sudah dihitung sebelumnya
                SqlDataAdapter da = new SqlDataAdapter(@"
                SELECT w.WorkLogId, p.productName, w.StartTime, w.EndTime, 
                       w.TotalTime, s.statusName
                FROM WorkLogNew w
                INNER JOIN products p ON w.ProductId = p.productId
                INNER JOIN statuses s ON w.StatusId = s.statusId
                WHERE w.UserId = @UserId
                ORDER BY w.CreatedAt DESC", conn);

                da.SelectCommand.Parameters.AddWithValue("@UserId", userId);

                DataTable dt = new DataTable();
                da.Fill(dt);

                StringBuilder sb = new StringBuilder();
                int rowIndex = 1;

                foreach (DataRow row in dt.Rows)
                {
                    sb.Append("<tr data-worklog-id='" + row["WorkLogId"] + "' data-total-time='" + row["TotalTime"] + "' data-status='" + row["statusName"] + "'>");

                    sb.AppendFormat("<td style='text-align: center;'>{0}</td>", rowIndex);
                    sb.AppendFormat("<td>{0}</td>", row["productName"]);
                    sb.AppendFormat("<td>{0}</td>", Convert.ToDateTime(row["StartTime"]).ToString("dd-MM-yyyy HH:mm"));

                    // Menangani nilai NULL pada EndTime
                    //sb.AppendFormat("<td>{0}</td>", row.IsNull("EndTime") ? "" : Convert.ToDateTime(row["EndTime"]).ToString("dd-MM-yyyy HH:mm"));

                    //sb.AppendFormat("<td>{0}</td>", Convert.ToDateTime(row["CreatedAt"]).ToString("dd-MM-yyyy HH:mm"));

                    // Menangani nilai NULL pada TotalTime dan memastikan hanya menampilkan jam:menit:detik jika ada
                    int totalSeconds = row.IsNull("TotalTime") ? 0 : Convert.ToInt32(row["TotalTime"]);
                    TimeSpan timeSpan = TimeSpan.FromSeconds(totalSeconds);
                    sb.AppendFormat("<td style='text-align: center;'>{0}</td>", timeSpan.ToString(@"hh\:mm\:ss"));

                    string statusName = row["statusName"].ToString();
                    string badgeClass = statusName == "On Progress" ? "badge badge-warning blink" : "badge badge-success";
                    sb.AppendFormat("<td style='text-align:center'><span class='{0}'>{1}</span></td>", badgeClass, statusName);

                    sb.AppendFormat("<td style='text-align:center'><button type='button' class='btn btn-primary' onclick='markAsCompleted({0})'>Done</button></td>", row["WorkLogId"]);
                    sb.Append("</tr>");
                    rowIndex++;
                }

                workLogTBody.InnerHtml = sb.ToString();
            }
        }
        //DataTables



        [System.Web.Services.WebMethod]
        public static void UpdateTotalTime(int workLogId, int totalTime)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string updateQuery = @"
            UPDATE WorkLogNew
            SET TotalTime = @TotalTime
            WHERE WorkLogId = @WorkLogId";

                SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                updateCmd.Parameters.AddWithValue("@TotalTime", totalTime);
                updateCmd.Parameters.AddWithValue("@WorkLogId", workLogId);

                conn.Open();
                updateCmd.ExecuteNonQuery();
                conn.Close();
            }
        }



        [System.Web.Services.WebMethod]
        public static void MarkWorkLogAsCompleted(int workLogId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Ambil StartTime dari WorkLog berdasarkan WorkLogId
                string selectQuery = "SELECT StartTime FROM WorkLogNew WHERE WorkLogId = @WorkLogId";
                SqlCommand selectCmd = new SqlCommand(selectQuery, conn);
                selectCmd.Parameters.AddWithValue("@WorkLogId", workLogId);

                conn.Open();
                SqlDataReader reader = selectCmd.ExecuteReader();

                DateTime startTime = DateTime.MinValue;

                if (reader.HasRows)
                {
                    reader.Read();
                    startTime = reader.GetDateTime(0); // Ambil StartTime yang sudah ada
                }
                reader.Close();

                // Update EndTime menjadi waktu sekarang dan set StatusId menjadi 2 (Completed)
                string updateQuery = @"
                UPDATE WorkLogNew
                SET EndTime = @EndTime, 
                    StatusId = 2 -- Completed
                WHERE WorkLogId = @WorkLogId";

                SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                DateTime now = DateTime.Now; // Waktu sekarang
                updateCmd.Parameters.AddWithValue("@EndTime", now);
                updateCmd.Parameters.AddWithValue("@WorkLogId", workLogId);

                updateCmd.ExecuteNonQuery();
                conn.Close();
            }
        }



        //APACHE ECHARTS
        [System.Web.Services.WebMethod]
        public static object GetWorkLogDataForChart(string startDate, string endDate)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
            List<string> labels = new List<string>();
            List<int> data = new List<int>();
            int userId = Convert.ToInt32(HttpContext.Current.Session["userId"]); // Ambil userId dari session

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                SELECT 
                    CAST(StartTime AS DATE) AS WorkDate, 
                    COUNT(*) AS TotalWork
                FROM WorkLogNew
                WHERE UserId = @UserId AND StartTime BETWEEN @StartDate AND @EndDate
                GROUP BY CAST(StartTime AS DATE)
                ORDER BY WorkDate";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@StartDate", startDate);
                cmd.Parameters.AddWithValue("@EndDate", endDate);
                cmd.Parameters.AddWithValue("@UserId", userId);  // Filter berdasarkan userId

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    labels.Add(Convert.ToDateTime(reader["WorkDate"]).ToString("dd-MM-yyyy"));
                    data.Add(Convert.ToInt32(reader["TotalWork"]));
                }
                conn.Close();
            }

            return new { labels, data };
        }
    }
}
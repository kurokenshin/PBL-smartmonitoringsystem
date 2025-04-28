using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace SmartMonitoringSystemv1._5
{
    public partial class engineer_dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            // Cek jika session "userId" tidak ada, maka redirect ke login
            if (Session["userId"] == null)
            {
                Response.Redirect("login.aspx");
            }

            // Jika bukan POST (misalnya reload halaman), kita isi data ke dalam tabel
            if (!IsPostBack)
            {
                LoadUserPerformance();
            }


        }


        //APACHE ECHARTS
        [System.Web.Services.WebMethod]
        public static object GetCompletedTasksData()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

            List<string> dates = new List<string>();
            List<int> completedTasks = new List<int>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                SELECT CAST(EndTime AS DATE) AS WorkDate, COUNT(*) AS TotalCompleted
                FROM WorkLogNew
                WHERE StatusId = 2 AND EndTime >= DATEADD(DAY, -7, GETDATE())
                GROUP BY CAST(EndTime AS DATE)
                ORDER BY WorkDate";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    dates.Add(Convert.ToDateTime(reader["WorkDate"]).ToString("dd-MM-yyyy"));
                    completedTasks.Add(Convert.ToInt32(reader["TotalCompleted"]));
                }
                conn.Close();
            }

            // Debugging log untuk memastikan data
            System.Diagnostics.Debug.WriteLine("Dates: " + string.Join(",", dates));
            System.Diagnostics.Debug.WriteLine("Tasks: " + string.Join(",", completedTasks));

            return new { dates, completedTasks };
        }



        [System.Web.Services.WebMethod]
        public static object GetUserPerformanceData()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

            List<string> usernames = new List<string>();
            List<int> totalCompletedTasks = new List<int>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                u.Username, 
                COUNT(w.WorkLogId) AS TotalCompletedTasks
            FROM 
                Users u
            LEFT JOIN 
                WorkLogNew w ON u.UserId = w.UserId AND w.StatusId = 2
            WHERE 
                u.is_employee = 1
            GROUP BY 
                u.Username
            ORDER BY 
                TotalCompletedTasks DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    usernames.Add(reader["Username"].ToString());
                    totalCompletedTasks.Add(Convert.ToInt32(reader["TotalCompletedTasks"]));
                }
                conn.Close();
            }

            return new { usernames, totalCompletedTasks };
        }
        //APACHE ECHARTS



        private void LoadUserPerformance()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;

            List<string> usernames = new List<string>();
            List<int> finishedToday = new List<int>();
            List<string> averageWorkmanship = new List<string>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT u.Username, 
                        (SELECT COUNT(*) FROM WorkLogNew WHERE UserId = u.UserId AND CAST(StartTime AS DATE) = CAST(GETDATE() AS DATE) AND StatusId = 2) AS FinishedToday,
                        (SELECT ISNULL(AVG(TotalTime), 0) FROM WorkLogNew WHERE UserId = u.UserId AND StatusId = 2) AS AverageWorkmanship
                    FROM Users u
                    WHERE u.is_employee = 1";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    usernames.Add(reader["Username"].ToString());
                    finishedToday.Add(Convert.ToInt32(reader["FinishedToday"]));

                    int avgWorkSeconds = Convert.ToInt32(reader["AverageWorkmanship"]);
                    TimeSpan avgTimeSpan = TimeSpan.FromSeconds(avgWorkSeconds);
                    string avgWorkFormatted = string.Format("{0:D2}:{1:D2}:{2:D2}",
                        avgTimeSpan.Hours, avgTimeSpan.Minutes, avgTimeSpan.Seconds);
                    averageWorkmanship.Add(avgWorkFormatted);
                }
                conn.Close();
            }

            // Generate the HTML for the table body
            StringBuilder tableBodyHtml = new StringBuilder();
            for (int i = 0; i < usernames.Count; i++)
            {
                tableBodyHtml.Append("<tr>");
                tableBodyHtml.Append($"<td>{usernames[i]}</td>");
                tableBodyHtml.Append($"<td>{finishedToday[i]}</td>");
                tableBodyHtml.Append($"<td>{averageWorkmanship[i]}</td>");
                tableBodyHtml.Append("</tr>");
            }

            // Set the generated HTML into the tbody of the table
            userTableBody.InnerHtml = tableBodyHtml.ToString();
        }



    }
}
using System;
using System.Configuration;
using System.Data.SqlClient;

namespace SmartMonitoringSystemv1._5
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Jika sudah login, redirect ke halaman yang sesuai berdasarkan peran
                if (Session["username"] != null)
                {
                    // Cek peran yang disimpan di session dan arahkan ke halaman yang sesuai
                    if (Session["is_employee"] != null && Convert.ToBoolean(Session["is_employee"]))
                    {
                        Response.Redirect("employee_dashboard.aspx");
                    }
                    else if (Session["is_engineer"] != null && Convert.ToBoolean(Session["is_engineer"]))
                    {
                        Response.Redirect("engineer_dashboard.aspx");
                    }
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text; // Ambil nilai dari input Username
            string password = txtPassword.Text; // Ambil nilai dari input Password

            string connectionString = ConfigurationManager.ConnectionStrings["dbconnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT userId, username, is_employee, is_engineer FROM users WHERE username = @username AND password = @password";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@username", username);
                cmd.Parameters.AddWithValue("@password", password); // Pastikan hashing password

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        // Set session
                        Session["userId"] = Convert.ToInt32(reader["userId"]); // Menyimpan userId
                        Session["username"] = reader["username"].ToString();
                        Session["is_employee"] = Convert.ToBoolean(reader["is_employee"]);
                        Session["is_engineer"] = Convert.ToBoolean(reader["is_engineer"]);

                        // Redirect berdasarkan peran
                        if (Convert.ToBoolean(reader["is_employee"]))
                        {
                            Response.Redirect("employee_dashboard.aspx");
                        }
                        else if (Convert.ToBoolean(reader["is_engineer"]))
                        {
                            Response.Redirect("engineer_dashboard.aspx");
                        }
                    }
                }
                else
                {
                    // Invalid login
                    Response.Write("<script>alert('Invalid username or password!');</script>");
                }
                conn.Close();
            }
        }
    }
}


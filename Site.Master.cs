using System;

namespace SmartMonitoringSystemv1._5
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Cek apakah user sudah login
                if (Session["username"] != null)
                {
                    // Tampilkan nama user
                    userName.InnerText = Session["username"].ToString();

                    // Tampilkan role user
                    if (Session["is_employee"] != null && (bool)Session["is_employee"])
                    {
                        userRole.InnerText = "Karyawan";
                    }
                    else if (Session["is_engineer"] != null && (bool)Session["is_engineer"])
                    {
                        userRole.InnerText = "Engineer";
                    }
                }
                else
                {
                    // Jika belum login, redirect ke halaman login
                    Response.Redirect("login.aspx");
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Hapus semua session
            Session.Clear();
            Session.Abandon();

            // Redirect ke halaman login
            Response.Redirect("login.aspx");
        }
    }
}

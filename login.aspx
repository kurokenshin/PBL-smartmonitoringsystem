<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="SmartMonitoringSystemv1._5.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <meta http-equiv="Content-Language" content="en" />
    <meta name="msapplication-TileColor" content="#2d89ef" />
    <meta name="theme-color" content="#4188c9" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="mobile-web-app-capable" content="yes" />
    <meta name="HandheldFriendly" content="True" />
    <meta name="MobileOptimized" content="320" />
    <link rel="icon" href="assets/logopolibatam2.png" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="./favicon.ico" />
    <!-- Generated: 2018-04-06 16:27:42 +0200 -->
    <title>Dashboard Login</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,300i,400,400i,500,500i,600,600i,700,700i&amp;subset=latin-ext" />
    <script src="assets/js/require.min.js"></script>
    <script>
        requirejs.config({
            baseUrl: '.'
        });
  </script>
    <!-- Dashboard Core -->
    <link href="assets/css/dashboard.css" rel="stylesheet" />
    <script src="assets/js/dashboard.js"></script>
    <!-- c3.js Charts Plugin -->
    <link href="assets/plugins/charts-c3/plugin.css" rel="stylesheet" />
    <script src="assets/plugins/charts-c3/plugin.js"></script>
    <!-- Google Maps Plugin -->
    <link href="assets/plugins/maps-google/plugin.css" rel="stylesheet" />
    <script src="assets/plugins/maps-google/plugin.js"></script>
    <!-- Input Mask Plugin -->
    <script src="assets/plugins/input-mask/plugin.js"></script>


    <style>
        /* Style untuk form login */
        .custom-login {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .custom-login-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 500px;
        }

        .custom-login-header {
            text-align: center;
            margin-bottom: 24px;
        }

            .custom-login-header img {
                height: 80px;
            }

        .custom-login-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 16px;
            text-align: center;
        }

        .custom-form-group {
            margin-bottom: 16px;
        }

        .custom-form-label {
            font-weight: bold;
        }

        .custom-form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

            .custom-form-control:focus {
                border-color: #80bdff;
                outline: 0;
                box-shadow: 0 0 5px rgba(128, 189, 255, 0.5);
            }

        .custom-form-footer {
            margin-top: 16px;
        }

        .custom-btn {
            display: inline-block;
            font-weight: 600;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
            user-select: none;
            border: 1px solid transparent;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            line-height: 1.5;
            border-radius: 0.375rem;
            transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            color: #fff;
            background-color: #007bff;
            border-color: #007bff;
            width: 100%;
        }

            .custom-btn:hover {
                background-color: #0056b3;
                border-color: #004085;
            }

        .custom-text-muted {
            color: #6c757d;
            text-align: center;
            margin-top: 16px;
        }

            .custom-text-muted a {
                color: #007bff;
                text-decoration: none;
            }

                .custom-text-muted a:hover {
                    color: #0056b3;
                    text-decoration: underline;
                }
    </style>

</head>

<body>
    <form id="form1" runat="server" class="custom-login">
        <div class="custom-login-card">
            <div class="custom-login-header">
                <img src="assets/TRPL.png" alt="Polibatam" />
            </div>

            <div class="card-body">
                <div class="custom-login-title">Login to your account</div>
                <div class="custom-form-group">
                    <label class="custom-form-label">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="custom-form-control" Placeholder="Enter Username"></asp:TextBox>
                </div>
                <div class="custom-form-group">
                    <label class="custom-form-label">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="custom-form-control" TextMode="Password" Placeholder="Password"></asp:TextBox>
                </div>
                <div class="custom-form-footer">
                    <asp:Button ID="btnLogin" runat="server" CssClass="custom-btn" Text="Sign in" OnClick="btnLogin_Click" />
                </div>
            </div>

            <div class="custom-text-muted">
                Don't have account yet? <a href="./register.html">Sign up</a>
            </div>
        </div>
    </form>


</body>
</html>

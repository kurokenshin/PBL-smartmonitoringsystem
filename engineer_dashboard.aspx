<%@ Page MasterPageFile="~/Site.Master" Title="Smart Monitoring System" Language="C#" AutoEventWireup="true" CodeBehind="engineer_dashboard.aspx.cs" Inherits="SmartMonitoringSystemv1._5.engineer_dashboard" %>


<asp:Content runat="server" ID="content1" ContentPlaceHolderID="head">
    <!-- CSS DataTables -->
    <link href="https://cdn.datatables.net/1.12.1/css/jquery.dataTables.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/buttons/2.2.2/css/buttons.dataTables.min.css" rel="stylesheet">

    <!-- JS DataTables -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.12.1/js/jquery.dataTables.min.js"></script>

    <!-- JS DataTables Buttons -->
    <script src="https://cdn.datatables.net/buttons/2.2.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>

    <!-- Library untuk membuat file Excel -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.2.2/js/buttons.html5.min.js"></script>

    <%--LINK UNTUK APACHE ECHARTS--%>
    <script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>



    <style>
        /* Material Design Styling untuk tabel */
        #userTable {
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
            overflow: hidden;
            transition: box-shadow 0.3s ease;
        }

            /* Hover effect pada tabel */
            #userTable tbody tr:hover {
                background-color: #f1f1f1;
                cursor: pointer;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            }

            /* Styling untuk baris data */
            #userTable tbody tr {
                background-color: #ffffff;
                border-bottom: 1px solid #ddd;
            }

            /* Padding dan spacing cell tabel */
            #userTable th, #userTable td {
                padding: 16px 24px;
                text-align: left;
                font-size: 1rem;
            }

            /* Styling Header tabel */
            #userTable th {
                font-weight: 500;
                background-color: #FFFFFF;
                color: black;
            }

            /* Baris data genap dengan latar belakang lebih terang */
            #userTable tbody tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            /* Menambah transisi pada hover baris */
            #userTable tbody tr {
                transition: background-color 0.3s ease;
            }

            /* Menambah shadow saat hover */
            #userTable td {
                transition: box-shadow 0.2s ease;
            }

                #userTable td:hover {
                    box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.1);
                }

        /* Styling untuk card header */
        .card-header {
            border-bottom: 2px solid #ddd;
        }

        /* Set font family dan mengatur gaya teks */
        #userTable {
            font-family: 'Roboto', sans-serif;
        }
    </style>



</asp:Content>



<asp:Content runat="server" ID="content2" ContentPlaceHolderID="main">
    <div class="my-3 my-md-5">
        <div class="container-fluid">
            <div class="page-header">
                <%--<h1 class="page-title">Dashboard</h1>--%>
            </div>
            <div class="row row-cards">
                <%--kotak kecil--%>
                <%--<div class="col-6 col-sm-4 col-lg-2">
                    <div class="card">
                        <div class="card-body p-3 text-center">
                            <div class="text-right text-green">
                                6%
                 
                                                <i class="fe fe-chevron-up"></i>
                            </div>
                            <div class="h1 m-0">43</div>
                            <div class="text-muted mb-4">New Tickets</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-lg-2">
                    <div class="card">
                        <div class="card-body p-3 text-center">
                            <div class="text-right text-red">
                                -3%
                 
                                                <i class="fe fe-chevron-down"></i>
                            </div>
                            <div class="h1 m-0">17</div>
                            <div class="text-muted mb-4">Closed Today</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-lg-2">
                    <div class="card">
                        <div class="card-body p-3 text-center">
                            <div class="text-right text-green">
                                9%
                 
                                                <i class="fe fe-chevron-up"></i>
                            </div>
                            <div class="h1 m-0">7</div>
                            <div class="text-muted mb-4">New Replies</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-lg-2">
                    <div class="card">
                        <div class="card-body p-3 text-center">
                            <div class="text-right text-green">
                                3%
                 
                                                <i class="fe fe-chevron-up"></i>
                            </div>
                            <div class="h1 m-0">27.3K</div>
                            <div class="text-muted mb-4">Followers</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-lg-2">
                    <div class="card">
                        <div class="card-body p-3 text-center">
                            <div class="text-right text-red">
                                -2%
                 
                                                <i class="fe fe-chevron-down"></i>
                            </div>
                            <div class="h1 m-0">$95</div>
                            <div class="text-muted mb-4">Daily Earnings</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-lg-2">
                    <div class="card">
                        <div class="card-body p-3 text-center">
                            <div class="text-right text-red">
                                -1%
                 
                                                <i class="fe fe-chevron-down"></i>
                            </div>
                            <div class="h1 m-0">621</div>
                            <div class="text-muted mb-4">Products</div>
                        </div>
                    </div>
                </div>--%>
                <%--kotak kecil--%>


                <%--tabel Total Work Completed--%>
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Total Work Completed</h3>
                        </div>
                        <div id="totalChart" style="height: 500px;"></div>
                    </div>
                </div>
                <%--tabel Total Work Completed--%>



                <%--tabel User Performance--%>
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">User Performance</h3>
                        </div>
                        <div id="userPerformanceChart" style="height: 500px;"></div>
                    </div>
                </div>
                <%--tabel User Performance--%>
            </div>

            <%-- Tabel User --%>
            <div class="row row-cards row-deck">
                <div class="col-12">
                    <div class="card" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
                        <div class="card-header" style="background-color: #FFFFFF; color: black; padding: 16px;">
                            <h3 class="card-title" style="font-size: 1.125rem; margin: 0;">User Monitoring Dashboard Performance</h3>
                        </div>
                        <div class="table-responsive">
                            <table id="userTable" class="display table table-striped" style="width: 100%; border-collapse: collapse; font-family: 'Roboto', sans-serif; background-color: white; border-radius: 8px; overflow: hidden;">
                                <thead>
                                    <tr style="background-color: #FFFFFF; color: black; font-weight: 500; text-align: left; border-bottom: 1px solid #ddd;">
                                        <th style="padding: 16px 24px; font-size: 1rem;">Username</th>
                                        <th style="padding: 16px 24px; font-size: 1rem;">Finished Today</th>
                                        <th style="padding: 16px 24px; font-size: 1rem;">Average Workmanship</th>
                                    </tr>
                                </thead>
                                <tbody id="userTableBody" runat="server">
                                    <!-- Data rows will be inserted here by DataTables -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <%-- Tabel User --%>
        </div>
    </div>


    <script>
        $(document).ready(function () {


            // Inisialisasi DataTables
            const dataTable = $('#userTable').DataTable({
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Excel',
                        title: 'Work Log',
                        exportOptions: {
                            modifier: {
                                page: 'all'
                            }
                        }
                    }
                ]
            });




            // Chart 1: Total Tasks Completed Over the Last 7 Days
            const totalChartDom = document.getElementById("totalChart"); // Ubah nama variabel
            const totalChart = echarts.init(totalChartDom); // Ubah nama variabel

            fetch("engineer_dashboard.aspx/GetCompletedTasksData", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
            })
                .then((response) => response.json())
                .then((data) => {
                    const result = data.d;
                    const dates = result.dates;
                    const completedTasks = result.completedTasks;

                    const totalChartOption = { // Ubah nama variabel untuk konfigurasi chart
                        title: {
                            /*text: "Tasks Completed Over the Last 7 Days",*/
                            left: "center",
                        },
                        tooltip: {
                            trigger: "axis",
                            axisPointer: { type: "shadow" },
                        },
                        xAxis: {
                            type: "category",
                            data: dates,
                            axisLabel: { rotate: 45 },
                        },
                        yAxis: {
                            type: "value",
                            /*name: "Tasks Completed",*/
                        },
                        series: [
                            {
                                name: "Total",
                                type: "bar",
                                data: completedTasks,
                                itemStyle: {
                                    color: "#5470C6",
                                },
                                label: {
                                    show: true,
                                    position: 'inside', // Menempatkan label di dalam bar
                                    color: "#fff", // Warna teks label
                                },
                            },
                            {
                                name: "Tasks (Line)",
                                type: "line",
                                data: completedTasks,
                                smooth: true,  // Membuat garis lebih halus
                                itemStyle: {
                                    color: "#FF5733",
                                    width: 2,
                                },
                                symbol: "circle",
                                symbolSize: 8,
                                symbolStyle: { // Menambahkan style untuk simbol
                                    color: "#66CC66", // Warna hijau untuk simbol lingkaran
                                },
                                tooltip: {
                                    show: false, // Menonaktifkan tooltip untuk garis line chart
                                },
                            },
                        ],
                    };

                    totalChart.setOption(totalChartOption);
                })
                .catch((error) => console.error("Error fetching chart data:", error));



            // Chart 2: User Performance
            const userPerformanceChartDom = document.getElementById("userPerformanceChart"); // Ubah nama variabel
            const userPerformanceChart = echarts.init(userPerformanceChartDom); // Ubah nama variabel

            fetch("engineer_dashboard.aspx/GetUserPerformanceData", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
            })
                .then((response) => response.json())
                .then((data) => {
                    const usernames = data.d.usernames;
                    const totalCompletedTasks = data.d.totalCompletedTasks;

                    const userPerformanceChartOption = { // Ubah nama variabel untuk konfigurasi chart
                        title: {
                            /*text: "User Performance",*/
                            left: "center",
                        },
                        tooltip: {
                            trigger: "axis",
                            axisPointer: { type: "shadow" },
                        },
                        xAxis: {
                            type: "category",
                            data: usernames,
                            axisLabel: { rotate: 45 },
                        },
                        yAxis: {
                            type: "value",
                            /*name: "Tasks Completed",*/
                        },
                        series: [
                            {
                                name: "Total",
                                type: "bar",
                                data: totalCompletedTasks,
                                itemStyle: {
                                    color: "#91CC75",
                                },
                                label: {
                                    show: true,
                                    position: 'inside', // Menempatkan label di dalam bar
                                    color: "#fff", // Warna teks label
                                },
                            },
                        ],
                    };

                    userPerformanceChart.setOption(userPerformanceChartOption);
                })
                .catch((error) => console.error("Error fetching user performance data:", error));

        });
    </script>


</asp:Content>



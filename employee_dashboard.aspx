<%@ Page MasterPageFile="~/Site.Master" Title="Smart Monitoring System" Language="C#" AutoEventWireup="true" CodeBehind="employee_dashboard.aspx.cs" Inherits="SmartMonitoringSystemv1._5.employee_dashboard" %>


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
        .dropdown-container {
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

            .dropdown-container .form-control {
                width: 400px; /* Atur lebar dropdown sesuai kebutuhan */
            }




        .card-header {
            background-color: #007bff;
            color: black;
            padding: 10px;
        }

        .card-title {
            margin: 0;
        }

        .dropdown-container .form-control {
            width: auto;
        }

        .table-responsive {
            margin-top: 20px;
        }

        #workLogTable {
            width: 100%;
            border-collapse: collapse;
            box-shadow: 0 2px 3px rgba(0, 0, 0, 0.1);
        }

            #workLogTable th, #workLogTable td {
                padding: 12px 15px;
                border: 1px solid #ddd;
                color: black; /* Warna teks hitam */
            }

            #workLogTable thead {
                background-color: white; /* Warna latar belakang putih */
                color: black; /* Warna teks hitam */
            }

            #workLogTable tbody tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            #workLogTable tbody tr:hover {
                background-color: #ddd;
            }

            #workLogTable th {
                text-align: left;
            }

            #workLogTable .actions {
                text-align: center;
            }

        
        @keyframes blink {
            50% {
                opacity: 0;
            }
        }

        .blink {
            animation: blink 1s linear infinite;
        }


        .badge {
            display: inline-block;
            padding: 0.5em 0.75em;
            font-size: 0.875rem;
            font-weight: 600;
            line-height: 1;
            color: #fff;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 0.25rem;
        }

        .badge-warning {
            background-color: #ffc107; /* Warna kuning */
            color: #212529; /* Warna teks */
            animation: blink 1.5s linear infinite; /* Tambahkan animasi blink */
        }

        .badge-success {
            background-color: #28a745; /* Warna hijau */
            color: #fff; /* Warna teks */
        }


        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-section {
            display: flex;
            align-items: flex-end;
            gap: 10px;
        }

            .filter-section .mr-2 {
                margin-right: 10px;
            }

        #startDate, #endDate {
            width: 100%;
        }

        #filterButton {
            margin-top: 24px; /* Sesuaikan agar tidak terlalu dekat dengan elemen lainnya */
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
                <div class="col-6 col-sm-4 col-lg-3">
                    <div class="card">
                        <div class="card-body p-3 text-center">
                            <div class="h1 m-0" id="finishedToday" style="margin-top: 10px !important;">0</div>
                            <div class="text-muted mb-4" style="margin-top: 8px;">Finished Today</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-lg-3">
                    <div class="card">
                        <div class="card-body p-3 text-center">
                            <div class="h1 m-0" id="averageWorkmanship" style="margin-top: 10px !important">0</div>
                            <div class="text-muted mb-4" style="margin-top: 8px;">Average Workmanship</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-lg-3">
                    <div class="card">
                        <div class="card-body p-3 text-center">
                            <div class="h1 m-0" id="totalWorkmanship" style="margin-top: 10px !important">0</div>
                            <div class="text-muted mb-4" style="margin-top: 8px;">Total Workmanship</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-sm-4 col-lg-3">
                    <div class="card">
                        <div class="card-body p-3 text-center">
                            <div class="h1 m-0" style="margin-top: 10px !important">0</div>
                            <div class="text-muted mb-4" style="margin-top: 8px;">Efficiency Score</div>
                        </div>
                    </div>
                </div>
                <%--kotak kecil--%>


                <%--tabel work--%>
                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                            <h3 class="card-title">Work Log</h3>
                            <div class="dropdown-container">
                                <!-- Dropdown untuk memilih produk -->
                                <asp:DropDownList ID="ddlProduct" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlProduct_SelectedIndexChanged">
                                    <asp:ListItem Text="Select Product" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table id="workLogTable" class="table table-striped" style="width: 100%">
                                <thead>
                                    <tr>
                                        <th style="text-align: center;">No.</th>
                                        <th>Product Code</th>
                                        <th>Start Time</th>
                                        <th style="text-align: center;">Total Time</th>
                                        <th style="text-align: center;">Status</th>
                                        <th class="actions">Actions</th>
                                    </tr>
                                </thead>
                                <tbody runat="server" id="workLogTBody">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <%--tabel work--%>


                <%--tabel development--%>
                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                            <h3 class="card-title mb-0">Development Activity</h3>
                            <div class="filter-section d-flex align-items-end">
                                <div class="mr-2">
                                    <label for="startDate">Start Date:</label>
                                    <input type="date" id="startDate" class="form-control">
                                </div>
                                <div class="mr-2">
                                    <label for="endDate">End Date:</label>
                                    <input type="date" id="endDate" class="form-control">
                                </div>
                                <button type="button" id="filterButton" class="btn btn-primary">Filter</button>
                            </div>
                        </div>
                        <div id="developmentChart" style="height: 480px;"></div>
                    </div>
                </div>
                <%--tabel development--%>

            </div>
        </div>
    </div>


    <script>
        // Definisikan fungsi markAsCompleted di luar $(document).ready()
        function markAsCompleted(workLogId) {
            console.log('markAsCompleted function called with workLogId: ' + workLogId);  // Debug log
            $.ajax({
                type: "POST",
                url: "employee_dashboard.aspx/MarkWorkLogAsCompleted",
                data: JSON.stringify({ workLogId: workLogId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function () {
                    const row = $(`#workLogTable tbody tr[data-worklog-id='${workLogId}']`);
                    row.data('status', 'Completed');
                    row.find('.status-column').text('Completed');
                    clearInterval(row.data('timerId'));

                    // Refresh halaman setelah berhasil menandai sebagai Completed
                    location.reload();

                },
                error: function (error) {
                    console.error("Error marking worklog as completed:", error);
                }
            });
        }

        $(document).ready(function () {

            // Ambil nilai dari ViewState yang diterima dari server
            const finishedToday = '<%= ViewState["FinishedToday"] %>';
            const averageWorkmanship = '<%= ViewState["AverageWorkmanship"] %>';
            const totalWorkmanship = '<%= ViewState["TotalWorkmanship"] %>';

            // Perbarui kartu dengan data
            $('#finishedToday').text(finishedToday);
            $('#averageWorkmanship').text(averageWorkmanship);
            $('#totalWorkmanship').text(totalWorkmanship);
       


            // Kosongkan nilai filter tanggal
            $('#startDate').val('');
            $('#endDate').val('');

            // Inisialisasi ECharts
            var chartDom = document.getElementById('developmentChart');
            var myChart = echarts.init(chartDom);


            /*ini default pada saat halaman pertama kali di load*/

            // Ambil tanggal hari ini
            const today = new Date();
            // Tambahkan satu hari ke tanggal hari ini
            const tomorrow = new Date(today);
            tomorrow.setDate(today.getDate() + 1); // Tambah 1 hari
            const endDate = tomorrow.toISOString().split('T')[0]; // Format tanggal untuk hari berikutnya
            const sevenDaysAgo = new Date(today - 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]; // 7 hari sebelumnya

            // Muat data grafik untuk rentang tanggal 7 hari terakhir
            loadChartData(sevenDaysAgo, endDate);

            /*ini default pada saat halaman pertama kali di load*/

            // Fungsi untuk memuat data grafik berdasarkan rentang tanggal
            function loadChartData(startDate, endDate) {
                $.ajax({
                    type: "POST",
                    url: "employee_dashboard.aspx/GetWorkLogDataForChart",
                    data: JSON.stringify({ startDate: startDate, endDate: endDate }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log("Start Date:", startDate);
                        console.log("End Date:", endDate);
                        const { labels, data } = response.d;

                        // Untuk membuat garis berdasarkan data bar chart
                        const lineData = data; // Ambil data yang sama dengan bar chart untuk garis

                        const option = {
                            title: {
                                text: 'Total Work Per Day',
                                left: 'center'
                            },
                            tooltip: {
                                trigger: 'axis',
                                axisPointer: {
                                    type: 'shadow'
                                },
                                // Tooltip akan menampilkan data hanya untuk seri 'bar' (total pekerjaan)
                                formatter: function (params) {
                                    // Filter untuk hanya menampilkan tooltip untuk seri 'bar' (bukan garis)
                                    let tooltipText = '';
                                    params.forEach(function (param) {
                                        if (param.seriesType === 'bar') {
                                            tooltipText += `${param.seriesName}: ${param.value}<br>`;
                                        }
                                    });
                                    return tooltipText;
                                }
                            },
                            xAxis: {
                                type: 'category',
                                data: labels
                            },
                            yAxis: {
                                type: 'value',
                                /*name: 'Total Work Per Day'*/
                            },
                            series: [
                                {
                                    name: 'Total Workmanship',
                                    type: 'bar',
                                    data: data,
                                    label: {
                                        show: true,
                                        position: 'inside', // Menempatkan label di dalam bar
                                        color: "#fff", // Warna teks label
                                    },
                                },
                                {
                                    name: 'Trend Garis',
                                    type: 'line',  // Jenis garis
                                    data: lineData,  // Data yang sama dengan bar chart
                                    smooth: true,  // Membuat garis lebih halus
                                    lineStyle: {
                                        color: '#FF5733',  // Ubah warna garis sesuai keinginan
                                        width: 2  // Ketebalan garis
                                    },
                                    symbol: 'circle',  // Menghilangkan simbol titik pada garis
                                    symbolSize: 8,
                                    tooltip: {
                                        show: false  // Menyembunyikan tooltip untuk garis tren
                                    }
                                }
                            ]
                        };

                        // Render grafik dengan opsi yang diperbarui
                        myChart.setOption(option);
                    },
                    error: function (error) {
                        console.error("Error fetching chart data:", error);
                    }
                });
            }



            // Event handler untuk tombol Filter
            $('#filterButton').click(function () {
                const startDate = $('#startDate').val();
                let endDate = $('#endDate').val();

                console.log("Start Date (filter):", startDate); // Debugging
                console.log("End Date (filter):", endDate); // Debugging

                // Set default value for endDate if it's empty
                if (!endDate) {
                    // Tambah 1 hari ke tanggal hari ini jika endDate kosong
                    const tomorrow = new Date(today);
                    tomorrow.setDate(today.getDate() + 1); // Tambah 1 hari
                    endDate = tomorrow.toISOString().split('T')[0]; // Set default endDate ke hari berikutnya
                }

                const finalStartDate = startDate || sevenDaysAgo;

                console.log("Final Start Date:", finalStartDate); // Debugging
                console.log("Final End Date:", endDate); // Debugging

                loadChartData(finalStartDate, endDate);
            });


            // Inisialisasi DataTables
            const dataTable = $('#workLogTable').DataTable({
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

            // Fungsi untuk memperbarui TotalTime secara real-time
            function updateRealTimeTotalTime() {
                $('#workLogTable tbody tr').each(function () {
                    const $row = $(this);
                    const status = $row.data('status'); // Ambil status dari atribut data

                    if (status === 'Completed') {
                        return; // Jangan pembaruan lagi tlol jika pekerjaan sudah selesai
                    }

                    const workLogId = $row.data('worklog-id');
                    const totalTimeCell = $row.find('td:nth-child(4)');
                    let totalTimeInSeconds = $row.data('total-time');
                    totalTimeInSeconds++;

                    // Kirim pembaruan TotalTime ke server
                    $.ajax({
                        type: "POST",
                        url: "employee_dashboard.aspx/UpdateTotalTime",
                        data: JSON.stringify({ workLogId: workLogId, totalTime: totalTimeInSeconds }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function () {
                            // Format waktu menjadi hh:mm:ss
                            const hours = Math.floor(totalTimeInSeconds / 3600);
                            const minutes = Math.floor((totalTimeInSeconds % 3600) / 60);
                            const seconds = totalTimeInSeconds % 60;
                            const formattedTime = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

                            // Perbarui waktu di UI
                            totalTimeCell.text(formattedTime);
                            $row.data('total-time', totalTimeInSeconds); // Perbarui atribut data
                        },
                        error: function (error) {
                            console.error("Error updating total time:", error);
                        }
                    });
                });

                // Jalankan lagi setiap detik
                setTimeout(updateRealTimeTotalTime, 1000);
            }

            // Attach event handler ke tombol "Done"
            $(document).on('click', '.btn-success', function () {
                const workLogId = $(this).closest('tr').data('worklog-id');
                console.log('Done button clicked for worklog:', workLogId);
                markAsCompleted(workLogId);  // Panggil fungsi di luar $(document).ready()
            });

            // Mulai pembaruan real-time untuk timer
            updateRealTimeTotalTime();
        });
    </script>


</asp:Content>



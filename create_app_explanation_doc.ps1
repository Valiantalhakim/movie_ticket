$ErrorActionPreference = 'Stop'

$outputPath = Join-Path (Get-Location) 'Penjelasan_Cara_Kerja_Aplikasi_Movie_Ticket.docx'
$tempRoot = Join-Path (Get-Location) '.docx_build_temp'

if (Test-Path -LiteralPath $tempRoot) {
  Remove-Item -LiteralPath $tempRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $tempRoot | Out-Null
New-Item -ItemType Directory -Path (Join-Path $tempRoot '_rels') | Out-Null
New-Item -ItemType Directory -Path (Join-Path $tempRoot 'word') | Out-Null
New-Item -ItemType Directory -Path (Join-Path $tempRoot 'word/_rels') | Out-Null

function Escape-XmlText {
  param([string]$Text)
  return [System.Security.SecurityElement]::Escape($Text)
}

function New-Paragraph {
  param(
    [string]$Text,
    [string]$Style = 'Normal'
  )

  $escaped = Escape-XmlText $Text
  $styleXml = ''
  if ($Style -ne 'Normal') {
    $styleXml = "<w:pPr><w:pStyle w:val=`"$Style`"/></w:pPr>"
  }

  return "<w:p>$styleXml<w:r><w:t xml:space=`"preserve`">$escaped</w:t></w:r></w:p>"
}

function New-Bullet {
  param([string]$Text)
  $escaped = Escape-XmlText $Text
  return "<w:p><w:pPr><w:pStyle w:val=`"ListParagraph`"/><w:ind w:left=`"720`" w:hanging=`"360`"/></w:pPr><w:r><w:t xml:space=`"preserve`">- $escaped</w:t></w:r></w:p>"
}

$content = New-Object System.Collections.Generic.List[string]

$content.Add((New-Paragraph 'Penjelasan Cara Kerja Aplikasi Movie Ticket' 'Title'))
$content.Add((New-Paragraph 'Dokumen ini menjelaskan cara kerja aplikasi dengan bahasa sederhana, seperti penjelasan untuk user atau mentor intern.' 'Subtitle'))
$content.Add((New-Paragraph '1. Gambaran Umum' 'Heading1'))
$content.Add((New-Paragraph 'Movie Ticket adalah aplikasi pemesanan tiket bioskop. Di aplikasi ini user bisa masuk atau daftar akun, melihat daftar film, memilih jadwal tayang, memilih kursi, melihat ringkasan booking, memilih metode pembayaran, lalu mendapatkan e-ticket.'))
$content.Add((New-Paragraph 'Aplikasi ini dibuat memakai Flutter. Pengelolaan perpindahan halaman memakai GoRouter, sedangkan perubahan data di layar seperti loading, berhasil, error, pilihan kursi, dan pembayaran diatur memakai BLoC.'))

$content.Add((New-Paragraph '2. Alur Penggunaan Dari Sisi User' 'Heading1'))
$content.Add((New-Bullet 'User membuka aplikasi dan pertama kali masuk ke halaman Login.'))
$content.Add((New-Bullet 'Jika belum punya akun, user bisa pindah ke halaman Register.'))
$content.Add((New-Bullet 'Setelah login atau register berhasil, user diarahkan ke halaman Home.'))
$content.Add((New-Bullet 'Di Home, user melihat daftar film yang sedang tayang. User juga bisa mencari film dan memilih genre.'))
$content.Add((New-Bullet 'Saat user memilih salah satu film, aplikasi membuka halaman detail film.'))
$content.Add((New-Bullet 'Di detail film, user bisa melihat poster, genre, rating, durasi, sinopsis, dan jadwal tayang.'))
$content.Add((New-Bullet 'User memilih salah satu jadwal, lalu masuk ke halaman pemilihan kursi.'))
$content.Add((New-Bullet 'User memilih kursi yang masih tersedia. Total harga otomatis dihitung dari jumlah kursi dikali harga per kursi.'))
$content.Add((New-Bullet 'Setelah lanjut, user melihat ringkasan booking berisi film, bioskop, jadwal, kursi, jumlah tiket, dan total harga.'))
$content.Add((New-Bullet 'User lanjut ke pembayaran, memilih metode pembayaran, lalu konfirmasi.'))
$content.Add((New-Bullet 'Jika pembayaran berhasil, aplikasi menampilkan e-ticket dengan detail tiket dan tampilan QR Code.'))

$content.Add((New-Paragraph '3. Alur Halaman Aplikasi' 'Heading1'))
$content.Add((New-Paragraph 'Semua halaman dihubungkan melalui file app_routes.dart. File ini berperan seperti peta jalan aplikasi. Jadi saat user menekan tombol tertentu, aplikasi tahu harus pindah ke halaman mana.'))
$content.Add((New-Bullet '/ adalah halaman Login.'))
$content.Add((New-Bullet '/register adalah halaman Register.'))
$content.Add((New-Bullet '/home adalah halaman Home atau daftar film.'))
$content.Add((New-Bullet '/movie/:id adalah halaman detail film berdasarkan id film.'))
$content.Add((New-Bullet '/seat adalah halaman pilih kursi.'))
$content.Add((New-Bullet '/summary adalah halaman ringkasan booking.'))
$content.Add((New-Bullet '/payment adalah halaman pembayaran.'))
$content.Add((New-Bullet '/ticket adalah halaman e-ticket setelah pembayaran berhasil.'))

$content.Add((New-Paragraph '4. Cara Kerja Login dan Register' 'Heading1'))
$content.Add((New-Paragraph 'Login dan register di aplikasi ini masih berupa simulasi. Artinya aplikasi belum benar-benar mengecek akun ke server atau database online. Ketika user menekan tombol Masuk atau Daftar, aplikasi menampilkan proses loading sekitar dua detik, lalu dianggap berhasil.'))
$content.Add((New-Paragraph 'Bagian ini diatur oleh AuthBloc. AuthBloc menerima event seperti LoginEvent atau RegisterEvent, lalu mengubah state menjadi loading dan success. Setelah success, halaman diarahkan ke Home.'))

$content.Add((New-Paragraph '5. Cara Kerja Daftar Film' 'Heading1'))
$content.Add((New-Paragraph 'Saat halaman Home dibuka, aplikasi meminta data film ke MovieBloc. MovieBloc mengambil data dari use case GetNowPlaying. Use case ini mengambil data dari MovieRepository, lalu repository mengambil data dari MovieLocalDataSource.'))
$content.Add((New-Paragraph 'Karena datanya masih lokal, daftar film sudah ditulis langsung di dalam kode. Jadi aplikasi belum mengambil daftar film dari API internet.'))
$content.Add((New-Paragraph 'Di halaman Home, user bisa mencari film lewat kolom search. User juga bisa memilih genre seperti Action, Drama, Horror, Comedy, dan Sci-Fi. Filter ini dilakukan langsung di halaman Home berdasarkan data film yang sudah dimuat.'))

$content.Add((New-Paragraph '6. Cara Kerja Detail Film dan Jadwal' 'Heading1'))
$content.Add((New-Paragraph 'Saat user memilih film, aplikasi membawa id film ke halaman Movie Detail. Dari id itu, MovieBloc memuat detail film dan jadwal tayangnya.'))
$content.Add((New-Paragraph 'Halaman detail menampilkan informasi utama film seperti poster, judul, genre, rating, durasi, dan sinopsis. Di bagian bawah, aplikasi menampilkan jadwal tayang. Setiap jadwal punya bioskop, tanggal, jam, harga, dan jumlah kursi tersedia.'))
$content.Add((New-Paragraph 'Jika user menekan tombol booking pada salah satu jadwal, aplikasi membawa data jadwal tersebut ke halaman pilih kursi.'))

$content.Add((New-Paragraph '7. Cara Kerja Pemilihan Kursi' 'Heading1'))
$content.Add((New-Paragraph 'Di halaman pilih kursi, aplikasi memuat layout kursi berdasarkan showtimeId atau id jadwal tayang. Satu studio dibuat dengan 8 baris, yaitu A sampai H, dan setiap baris punya 8 kursi. Totalnya ada 64 kursi.'))
$content.Add((New-Paragraph 'Sebagian kursi dibuat otomatis menjadi booked atau sudah terisi. Kursi yang masih available bisa dipilih user. Ketika user memilih kursi, status kursi berubah menjadi selected. Jika user menekan kursi selected lagi, kursi tersebut dibatalkan.'))
$content.Add((New-Paragraph 'Total harga dihitung otomatis. Contohnya jika harga per kursi Rp50.000 dan user memilih 2 kursi, totalnya menjadi Rp100.000.'))

$content.Add((New-Paragraph '8. Cara Kerja Ringkasan Booking' 'Heading1'))
$content.Add((New-Paragraph 'Setelah memilih kursi, aplikasi membuat data booking sementara dengan status draft. Data ini dibawa ke halaman ringkasan.'))
$content.Add((New-Paragraph 'Di halaman ringkasan, user bisa mengecek lagi film, bioskop, jadwal, kursi, jumlah tiket, dan total harga. Jika user menekan Lanjut ke Pembayaran, BookingBloc akan membuat booking final.'))
$content.Add((New-Paragraph 'Saat booking dibuat, aplikasi mengecek apakah kursi yang dipilih masih kosong. Jika ada kursi yang ternyata sudah booked, aplikasi menampilkan error. Jika aman, kursi tersebut ditandai sebagai booked dan booking disimpan sementara di memori aplikasi.'))

$content.Add((New-Paragraph '9. Cara Kerja Pembayaran' 'Heading1'))
$content.Add((New-Paragraph 'Halaman pembayaran menampilkan total harga dan pilihan metode pembayaran. Metode yang tersedia adalah Kartu Kredit, E-Wallet, dan Transfer Bank.'))
$content.Add((New-Paragraph 'Pembayaran di aplikasi ini juga masih simulasi. Setelah user memilih metode dan menekan konfirmasi, PaymentBloc memproses pembayaran lalu mengubah state menjadi success. Setelah itu aplikasi pindah ke halaman e-ticket.'))

$content.Add((New-Paragraph '10. Cara Kerja E-Ticket' 'Heading1'))
$content.Add((New-Paragraph 'E-ticket adalah halaman terakhir setelah pembayaran berhasil. Halaman ini menampilkan QR Code secara visual, judul film, tanggal, jam, kursi, bioskop, dan metode pembayaran.'))
$content.Add((New-Paragraph 'QR Code yang tampil saat ini masih berupa tampilan placeholder, belum QR Code asli yang berisi data tiket. Untuk versi lebih lanjut, QR Code bisa dibuat dari id booking atau kode tiket unik.'))

$content.Add((New-Paragraph '11. Pembagian Struktur Kode' 'Heading1'))
$content.Add((New-Paragraph 'Project ini memakai pola pembagian fitur. Artinya kode tidak semuanya ditaruh dalam satu file, tetapi dipisah berdasarkan kebutuhan.'))
$content.Add((New-Bullet 'Folder core berisi hal umum yang dipakai banyak bagian, seperti warna aplikasi, route, widget tombol, widget input, formatter tanggal, formatter harga, dan dependency injection.'))
$content.Add((New-Bullet 'Folder features/auth berisi fitur login dan register.'))
$content.Add((New-Bullet 'Folder features/movies berisi fitur daftar film, detail film, dan jadwal tayang.'))
$content.Add((New-Bullet 'Folder features/booking berisi fitur pilih kursi dan pembuatan booking.'))
$content.Add((New-Bullet 'Folder features/payment berisi fitur pembayaran dan e-ticket.'))
$content.Add((New-Paragraph 'Dengan struktur seperti ini, kode lebih mudah dicari dan lebih mudah dikembangkan. Misalnya kalau mau mengubah tampilan tiket, kita cukup masuk ke folder payment. Kalau mau mengubah daftar film, kita masuk ke folder movies.'))

$content.Add((New-Paragraph '12. Cara Kerja BLoC Secara Gampang' 'Heading1'))
$content.Add((New-Paragraph 'BLoC bisa dibayangkan seperti petugas yang menerima perintah dari halaman. Halaman mengirim event, BLoC memproses, lalu BLoC mengirim state baru ke halaman.'))
$content.Add((New-Bullet 'Event adalah perintah, contohnya LoadMoviesEvent, SelectSeatEvent, atau ConfirmPaymentEvent.'))
$content.Add((New-Bullet 'State adalah kondisi layar, contohnya loading, berhasil, error, atau data sudah siap.'))
$content.Add((New-Bullet 'Page adalah tampilan yang dilihat user. Page hanya menampilkan data dan mengirim perintah saat user menekan sesuatu.'))
$content.Add((New-Paragraph 'Contoh gampang: saat user memilih kursi, halaman mengirim SelectSeatEvent ke SeatBloc. SeatBloc menghitung ulang daftar kursi dan total harga, lalu mengirim SeatLoaded ke halaman. Setelah itu halaman otomatis memperbarui tampilan kursi dan total harga.'))

$content.Add((New-Paragraph '13. Dependency Injection' 'Heading1'))
$content.Add((New-Paragraph 'Aplikasi ini memakai GetIt sebagai dependency injection. Bahasa gampangnya, GetIt adalah tempat daftar semua komponen penting. Jadi saat aplikasi butuh MovieBloc, BookingBloc, repository, atau datasource, aplikasi bisa mengambilnya dari satu tempat.'))
$content.Add((New-Paragraph 'Pengaturan ini ada di injection_container.dart. Tujuannya supaya pembuatan object lebih rapi dan tidak berantakan di setiap halaman.'))

$content.Add((New-Paragraph '14. Catatan Untuk Mentor atau Intern' 'Heading1'))
$content.Add((New-Bullet 'Aplikasi sudah punya alur booking lengkap dari login sampai e-ticket.'))
$content.Add((New-Bullet 'Data film, jadwal, kursi, login, booking, dan pembayaran masih simulasi atau lokal.'))
$content.Add((New-Bullet 'Belum ada backend asli, database permanen, atau validasi pembayaran nyata.'))
$content.Add((New-Bullet 'Jika aplikasi ditutup, data booking yang tersimpan di memori bisa hilang.'))
$content.Add((New-Bullet 'Hive sudah diinisialisasi di main.dart, tetapi pada alur saat ini data utama masih menggunakan datasource lokal di kode.'))
$content.Add((New-Bullet 'Untuk pengembangan berikutnya, aplikasi bisa disambungkan ke API film, database user, sistem booking backend, payment gateway, dan QR Code asli.'))

$content.Add((New-Paragraph '15. Kesimpulan' 'Heading1'))
$content.Add((New-Paragraph 'Secara sederhana, aplikasi ini bekerja seperti aplikasi pesan tiket bioskop: user login, pilih film, pilih jadwal, pilih kursi, cek ringkasan, bayar, lalu mendapatkan tiket. Dari sisi teknis, halaman dihubungkan oleh GoRouter, data layar diatur oleh BLoC, dan sumber data saat ini masih lokal.'))

$documentXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    $($content -join "`n    ")
    <w:sectPr>
      <w:pgSz w:w="11906" w:h="16838"/>
      <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="708" w:footer="708" w:gutter="0"/>
    </w:sectPr>
  </w:body>
</w:document>
"@

$contentTypesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
</Types>
"@

$relsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
"@

$documentRelsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"/>
"@

$stylesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:style w:type="paragraph" w:default="1" w:styleId="Normal">
    <w:name w:val="Normal"/>
    <w:qFormat/>
    <w:pPr><w:spacing w:after="160" w:line="276" w:lineRule="auto"/></w:pPr>
    <w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:sz w:val="22"/></w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Title">
    <w:name w:val="Title"/>
    <w:basedOn w:val="Normal"/>
    <w:next w:val="Normal"/>
    <w:qFormat/>
    <w:pPr><w:spacing w:after="240"/></w:pPr>
    <w:rPr><w:b/><w:sz w:val="36"/></w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Subtitle">
    <w:name w:val="Subtitle"/>
    <w:basedOn w:val="Normal"/>
    <w:next w:val="Normal"/>
    <w:qFormat/>
    <w:rPr><w:i/><w:color w:val="666666"/><w:sz w:val="22"/></w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Heading1">
    <w:name w:val="heading 1"/>
    <w:basedOn w:val="Normal"/>
    <w:next w:val="Normal"/>
    <w:qFormat/>
    <w:pPr><w:spacing w:before="280" w:after="120"/></w:pPr>
    <w:rPr><w:b/><w:color w:val="1F4E79"/><w:sz w:val="28"/></w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="ListParagraph">
    <w:name w:val="List Paragraph"/>
    <w:basedOn w:val="Normal"/>
    <w:qFormat/>
    <w:pPr><w:spacing w:after="100" w:line="276" w:lineRule="auto"/></w:pPr>
    <w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:sz w:val="22"/></w:rPr>
  </w:style>
</w:styles>
"@

[System.IO.File]::WriteAllText((Join-Path $tempRoot '[Content_Types].xml'), $contentTypesXml, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $tempRoot '_rels/.rels'), $relsXml, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $tempRoot 'word/document.xml'), $documentXml, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $tempRoot 'word/_rels/document.xml.rels'), $documentRelsXml, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path $tempRoot 'word/styles.xml'), $stylesXml, [System.Text.UTF8Encoding]::new($false))

if (Test-Path -LiteralPath $outputPath) {
  Remove-Item -LiteralPath $outputPath -Force
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($tempRoot, $outputPath)
Remove-Item -LiteralPath $tempRoot -Recurse -Force

Write-Output $outputPath

-- =================================================================
-- 1. TẠO TABLE, RÀNG BUỘC, INSERT DỮ LIỆU VÀ INDEX
-- =================================================================

-- Xóa DB nếu tồn tại để chạy lại từ đầu
DROP DATABASE IF EXISTS QuanLyRapPhim;
CREATE DATABASE CinemaAssigment;
USE CinemaAssigment;

-- Bảng Phim
CREATE TABLE Phim (
    IdPhim INT PRIMARY KEY IDENTITY(1,1),
    TenPhim NVARCHAR(255) NOT NULL,
    TheLoai NVARCHAR(100),
    ThoiLuong INT,
    DaoDien NVARCHAR(100),
    NgayKhoiChieu DATE
);

-- Bảng Phòng Chiếu
CREATE TABLE PhongChieu (
    IdPhong INT PRIMARY KEY IDENTITY(1,1),
    TenPhong NVARCHAR(50) NOT NULL UNIQUE,
    LoaiPhong NVARCHAR(50),
    SoLuongGhe INT
);

-- Bảng Ghế Ngồi
CREATE TABLE GheNgoi (
    IdGhe INT PRIMARY KEY IDENTITY(1,1),
    IdPhong INT,
    HangGhe VARCHAR(5),
    SoGhe INT,
    LoaiGhe NVARCHAR(50),
    TrangThai NVARCHAR(50) DEFAULT 'Normal',
    CONSTRAINT fk_ghe_phong FOREIGN KEY (IdPhong) REFERENCES PhongChieu(IdPhong)
);

-- Bảng Suất Chiếu
CREATE TABLE SuatChieu (
    MaSuatChieu INT PRIMARY KEY IDENTITY(1,1),
    IdPhim INT,
    IdPhong INT,
    NgayChieu DATE,
    GioBatDau TIME,
    GioKetThuc TIME,
    GiaVe DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_suat_phim FOREIGN KEY (IdPhim) REFERENCES Phim(IdPhim),
    CONSTRAINT fk_suat_phong FOREIGN KEY (IdPhong) REFERENCES PhongChieu(IdPhong),
    CONSTRAINT chk_giave CHECK (GiaVe >= 0),
    CONSTRAINT chk_thoigian CHECK (GioKetThuc > GioBatDau)
);

-- Bảng Khách Hàng
CREATE TABLE KhachHang (
    IdKhachHang INT PRIMARY KEY IDENTITY(1,1),
    HoTen NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Sdt VARCHAR(15) UNIQUE,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    DiemTichLuy INT DEFAULT 0,
    HangThanhVien NVARCHAR(50) DEFAULT 'Normal',
    CONSTRAINT chk_diem CHECK (DiemTichLuy >= 0)
);

-- Bảng Đặt Vé
CREATE TABLE DatVe (
    IdDatVe INT PRIMARY KEY IDENTITY(1,1),
    IdKhachHang INT,
    MaSuatChieu INT,
    NgayDat DATETIME DEFAULT CURRENT_TIMESTAMP,
    TongTien DECIMAL(10, 2),
    TrangThai NVARCHAR(50) DEFAULT 'Da thanh toan',
    CONSTRAINT fk_datve_khachhang FOREIGN KEY (IdKhachHang) REFERENCES KhachHang(IdKhachHang),
    CONSTRAINT fk_datve_suatchieu FOREIGN KEY (MaSuatChieu) REFERENCES SuatChieu(MaSuatChieu)
);

-- Bảng Chi Tiết Đặt Vé (Bảng trung gian)
CREATE TABLE ChiTietDatVe (
    IdDatVe INT,
    IdGhe INT,
    GiaVe DECIMAL(10, 2),
    PRIMARY KEY (IdDatVe, IdGhe),
    CONSTRAINT fk_chitiet_datve FOREIGN KEY (IdDatVe) REFERENCES DatVe(IdDatVe),
    CONSTRAINT fk_chitiet_ghe FOREIGN KEY (IdGhe) REFERENCES GheNgoi(IdGhe)
);	
Go
-- Bảng chi tiết thanh toán
CREATE TABLE ChiTietThanhToan(
    IdChiTietThanhToan INT PRIMARY KEY IDENTITY(1,1),
    IdDatVe INT NOT NULL,
    MaSuatChieu INT NOT NULL,
    IdGhe INT NOT NULL,
    GiaVe DECIMAL(10,2),
    TongTien DECIMAL(12,2),
    PhuongThucThanhToan NVARCHAR(30),
    TrangThai NVARCHAR(30),
    NgayThanhToan DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chitietthanhtoan_datve FOREIGN KEY (IdDatVe) REFERENCES DatVe(IdDatVe),
    CONSTRAINT fk_chitietthanhtoan_suatchieu FOREIGN KEY (MaSuatChieu) REFERENCES SuatChieu(MaSuatChieu),
    CONSTRAINT fk_chitietthanhtoan_ghe FOREIGN KEY (IdGhe) REFERENCES GheNgoi(IdGhe)
);GO

-- Dữ liệu mẫu
INSERT INTO Phim(TenPhim, TheLoai, ThoiLuong, DaoDien, NgayKhoiChieu) VALUES
('MAI', 'Tinh cam, Lang man', 131, 'Tran thanh', '2025-02-10'),
('Godzilla x Kong: The New Empire', 'Hanh Dong, Khoa hoc vien tuong', 115, 'Adam Wingard', '2025-03-29'),
('Vung Dat Cam Lang', 'Kinh di', 99, 'Michael Sarnoski', '2025-06-28');

INSERT INTO PhongChieu(TenPhong, LoaiPhong, SoLuongGhe) VALUES
('Cinema 1', 'IMAX', 10),
('Cinema 2', '4DX', 8);

INSERT INTO GheNgoi(IdPhong, HangGhe, SoGhe, LoaiGhe) VALUES
(1, 'A', 1, 'VIP'), (1, 'A', 2, 'VIP'), (1, 'A', 3, 'VIP'), (1, 'B', 1, 'Normal'), (1, 'B', 2, 'Normal'),
(2, 'A', 1, 'Couple'), (2, 'A', 2, 'Couple'), (2, 'B', 1, 'Couple'), (2, 'B', 2, 'Couple');

INSERT INTO SuatChieu(IdPhim, IdPhong, NgayChieu, GioBatDau, GioKetThuc, GiaVe) VALUES
(1, 1, '2025-11-05', '19:00:00', '21:11:00', 120000),
(2, 2, '2025-11-05', '20:30:00', '22:25:00', 150000),
(1, 1, '2025-11-06', '21:30:00', '23:41:00', 125000);

INSERT INTO KhachHang(HoTen, Email, Sdt, NgaySinh, GioiTinh, DiemTichLuy) VALUES
('Pham Anh Tuan', 'TuanAnh@email.com', '0987654321', '1995-03-20', 'Nam', 1500),
('Hua Trung Quan', 'quanHua@email.com', '0912345678', '2001-07-15', 'Nam', 500),
('Nguyen Duc Nguyen', 'nguyentran@email.com', '0912123678', '2001-07-15', 'Nữ', 500);

-- INSERT dữ liệu vào bảng DatVe
INSERT INTO DatVe (IdKhachHang, MaSuatChieu, NgayDat, TongTien, TrangThai) 
VALUES 
(1, 1, '2024-01-15 14:30:00', 180000.00, 'Da thanh toan'),
(2, 2, '2024-01-16 10:15:00', 240000.00, 'Da thanh toan'),
(3, 3, '2024-01-17 19:45:00', 120000.00, 'Cho thanh toan');

-- INSERT dữ liệu vào bảng ChiTietThanhToan
INSERT INTO ChiTietThanhToan (IdDatVe, MaSuatChieu, IdGhe, GiaVe, TongTien, PhuongThucThanhToan, TrangThai, NgayThanhToan) 
VALUES 
(1, 1, 5, 90000.00, 180000.00, N'Thẻ tín dụng', N'Hoàn thành', '2024-01-15 14:35:00'),
(1, 1, 6, 90000.00, 180000.00, N'Thẻ tín dụng', N'Hoàn thành', '2024-01-15 14:35:00'),
(2, 2, 12, 120000.00, 240000.00, N'Ví điện tử', N'Hoàn thành', '2024-01-16 10:20:00');

-- Cài đặt Index để tăng tốc truy vấn
CREATE INDEX idx_phim_theloai ON Phim(TheLoai);
CREATE INDEX idx_suatchieu_ngay ON SuatChieu(NgayChieu);
CREATE INDEX idx_khachhang_email ON KhachHang(Email);
Go

-- =================================================================
-- 2. CÁC CÂU TRUY VẤN
-- =================================================================

-- a. Tìm tất cả suất chiếu của phim 'MAI' vào ngày '2025-11-05'
SELECT p.TenPhim, pc.TenPhong, sc.NgayChieu, sc.GioBatDau, sc.GiaVe
FROM SuatChieu sc
JOIN Phim p ON sc.IdPhim = p.IdPhim
JOIN PhongChieu pc ON sc.IdPhong = pc.IdPhong
WHERE p.TenPhim = 'MAI' AND sc.NgayChieu = '2025-11-05';

-- b. Liệt kê tất cả các ghế còn trống cho suất chiếu có mã là 1
SELECT g.*
FROM GheNgoi g
WHERE g.IdPhong = (SELECT IdPhong FROM SuatChieu WHERE MaSuatChieu = 1)
AND g.IdGhe NOT IN (
    SELECT ctdv.IdGhe
    FROM ChiTietDatVe ctdv
    JOIN DatVe dv ON ctdv.IdDatVe = dv.IdDatVe
    WHERE dv.MaSuatChieu = 1
);

-- c. Tính tổng doanh thu trong ngày '2025-11-05'
SELECT SUM(dv.TongTien) AS TongDoanhThu
FROM DatVe dv
WHERE DATE(dv.NgayDat) = '2025-11-05';

-- d. Tìm 5 khách hàng có điểm tích lũy cao nhất
SELECT HoTen, Email, DiemTichLuy, HangThanhVien
FROM KhachHang
ORDER BY DiemTichLuy DESC
LIMIT 5;

-- e. Lấy lịch sử đặt vé của khách hàng có email 'anguyen@email.com'
SELECT dv.NgayDat, p.TenPhim, sc.NgayChieu, dv.TongTien
FROM DatVe dv
JOIN KhachHang kh ON dv.IdKhachHang = kh.IdKhachHang
JOIN SuatChieu sc ON dv.MaSuatChieu = sc.MaSuatChieu
JOIN Phim p ON sc.IdPhim = p.IdPhim
WHERE kh.Email = 'anguyen@email.com';


-- =================================================================
-- 3. CÁC TRIGGER
-- =================================================================

-- Trigger tự động cập nhật hạng thành viên dựa trên điểm tích lũy
CREATE TRIGGER trg_CapNhatHangThanhVien
ON KhachHang
AFTER UPDATE
AS
BEGIN
    IF UPDATE(DiemTichLuy)
    BEGIN
        UPDATE KhachHang
        SET HangThanhVien = 
            CASE 
                WHEN i.DiemTichLuy >= 5000 THEN N'Kim Cương'
                WHEN i.DiemTichLuy >= 2000 THEN N'Vàng'
                WHEN i.DiemTichLuy >= 500 THEN N'Bạc'
                ELSE N'Thường'
            END
        FROM KhachHang kh
        INNER JOIN inserted i ON kh.IdKhachHang = i.IdKhachHang
    END
END
GO

-- Trigger kiểm tra ghế đã được đặt hay chưa trước khi thêm vào ChiTietDatVe
CREATE TRIGGER trg_KiemTraGheDonGian
ON ChiTietThanhToan
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra ghế đã đặt
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN ChiTietThanhToan cttt ON i.MaSuatChieu = cttt.MaSuatChieu 
                                   AND i.IdGhe = cttt.IdGhe
        WHERE cttt.TrangThai IN (N'Đã đặt', N'Đã thanh toán')
    )
    BEGIN
        RAISERROR(N'Lỗi: Một hoặc nhiều ghế đã được đặt cho suất chiếu này.', 16, 1);
        RETURN;
    END

    -- Thực hiện insert nếu hợp lệ
    INSERT INTO ChiTietThanhToan 
    SELECT * FROM inserted;
    
    PRINT N'Đặt ghế thành công!';
END
GO
-- =================================================================
-- 4. CÁC THỦ TỤC VÀ HÀM
-- =================================================================


-- Thủ tục để thực hiện đặt vé
CREATE PROCEDURE sp_DatVe (
     @p_IdKhachHang INT,
     @p_MaSuatChieu INT,
     @p_DanhSachGhe VARCHAR(255) -- Danh sách ID ghế, ví dụ: '1,2,3'
)
AS
BEGIN
    DECLARE @tong_tien_ve DECIMAL(10, 2);
    DECLARE @gia_ve_don DECIMAL(10, 2);
    DECLARE @new_datve_id INT;
    DECLARE @ghe_id_str VARCHAR(255);
    DECLARE @ghe_id INT;

    -- Lấy giá vé từ suất chiếu
    SELECT GiaVe INTO gia_ve_don FROM SuatChieu WHERE MaSuatChieu = @p_MaSuatChieu;

    -- Tạo một đơn đặt vé mới
    INSERT INTO DatVe(IdKhachHang, MaSuatChieu, TongTien) VALUES (@p_IdKhachHang, @p_MaSuatChieu, 0);
    SET @new_datve_id = SCOPE_IDENTITY();

    -- Xử lý danh sách ghế
    SET @ghe_id_str = @p_DanhSachGhe;
    SET @tong_tien_ve = 0;
	

    WHILE LENGTH(@ghe_id_str) > 0
        SET @ghe_id = SUBSTRING(@ghe_id_str, ',', 1);
        
        -- Thêm vào chi tiết đặt vé
        INSERT INTO ChiTietDatVe(IdDatVe, IdGhe, GiaVe) VALUES (@new_datve_id, @ghe_id, @gia_ve_don);
        
        SET @tong_tien_ve = @tong_tien_ve + @gia_ve_don;

        IF LOCATE(',', @ghe_id_str) > 0 
            SET @ghe_id_str = SUBSTRING(@ghe_id_str, LEN(',', @ghe_id_str) + 1);
       ELSE
            SET @ghe_id_str = '';
        END 
    END WHILE; 

    -- Cập nhật tổng tiền cho đơn đặt vé
    UPDATE DatVe SET TongTien = @tong_tien_ve WHERE IdDatVe = @new_datve_id;

    -- Cập nhật điểm tích lũy cho khách hàng (ví dụ: 10,000đ = 1 điểm)
    UPDATE KhachHang SET DiemTichLuy = DiemTichLuy + FLOOR(@tong_tien_ve / 10000) WHERE IdKhachHang = p_IdKhachHang;

    COMMIT;
END

-- Hàm tính tổng doanh thu cho một phim cụ thể
CREATE FUNCTION fn_TinhDoanhThuPhim (
    @p_IdPhim INT
)
RETURNS DECIMAL(15, 2)
AS
BEGIN
    DECLARE @total_revenue DECIMAL(15, 2);
    
    SELECT @total_revenue = SUM(dv.TongTien)
    FROM DatVe dv
    JOIN SuatChieu sc ON dv.MaSuatChieu = sc.MaSuatChieu
    WHERE sc.IdPhim = @p_IdPhim;
    
    RETURN ISNULL(@total_revenue, 0);
END


-- Ví dụ cách gọi thủ tục và hàm
-- CALL sp_DatVe(1, 1, '4,5'); -- Khách hàng 1, đặt suất chiếu 1, ghế 4 và 5
-- SELECT fn_TinhDoanhThuPhim(1) AS 'Doanh thu phim MAI';
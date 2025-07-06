-- Tạo Database
CREATE DATABASE QuanLyKhoHang;
GO

USE QuanLyKhoHang;
GO

-- 1. Người dùng
CREATE TABLE NguoiDung (
    Id INT PRIMARY KEY IDENTITY,
    HoTen NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    VaiTro NVARCHAR(50) NOT NULL
);

-- 2. Tài khoản nhân viên
CREATE TABLE TaiKhoanNhanVien (
    Id INT PRIMARY KEY IDENTITY,
    NguoiDungId INT NOT NULL UNIQUE,
    TenDangNhap NVARCHAR(100) NOT NULL UNIQUE,
    MatKhau NVARCHAR(100) NOT NULL,
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Hoạt động',
    FOREIGN KEY (NguoiDungId) REFERENCES NguoiDung(Id)
);

-- 3. Khách hàng
CREATE TABLE KhachHang (
    MaKH INT PRIMARY KEY IDENTITY,
    Ten NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15) NOT NULL,
    DiaChi NVARCHAR(255),
    Email NVARCHAR(100)
);

-- 4. Sản phẩm
CREATE TABLE SanPham (
    MaSP INT PRIMARY KEY IDENTITY,
    Ten NVARCHAR(100) NOT NULL,
    Gia DECIMAL(18, 2) NOT NULL CHECK (Gia >= 0),
    DonViTinh NVARCHAR(50) NOT NULL,
    DonGiaNhap DECIMAL(18,2) NOT NULL CHECK (DonGiaNhap >= 0),
    DonGiaXuat DECIMAL(18,2) NOT NULL CHECK (DonGiaXuat >= 0),
    SoLuongTon INT NOT NULL CHECK (SoLuongTon >= 0),
    MoTa NVARCHAR(MAX)
);

-- 5. Nhà cung cấp
CREATE TABLE NhaCungCap (
    MaNCC INT PRIMARY KEY IDENTITY,
    TenNCC NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    Email NVARCHAR(100) NOT NULL UNIQUE,
    SoDienThoai VARCHAR(15) NOT NULL
);

-- 6. Phiếu nhập
CREATE TABLE PhieuNhap (
    MaPhieuNhap INT PRIMARY KEY IDENTITY,
    MaNCC INT NOT NULL,
    MaNV INT NOT NULL,
    NgayNhap DATE NOT NULL DEFAULT GETDATE(),
    GhiChu NVARCHAR(255),
    TrangThaiThanhToan BIT NOT NULL DEFAULT 1,
    NgayThanhToan DATE NULL,
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC),
    FOREIGN KEY (MaNV) REFERENCES NguoiDung(Id)
);

-- 7. Chi tiết phiếu nhập
CREATE TABLE ChiTietPhieuNhap (
    MaPhieuCT INT PRIMARY KEY IDENTITY,
    MaPhieuNhap INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(18, 2) NOT NULL CHECK (DonGia >= 0),
    FOREIGN KEY (MaPhieuNhap) REFERENCES PhieuNhap(MaPhieuNhap),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- 8. Đơn đặt hàng
CREATE TABLE DonDatHang (
    MaDonHang INT PRIMARY KEY IDENTITY,
    MaKH INT NOT NULL,
    MaNV INT,
    NgayDat DATE NOT NULL DEFAULT GETDATE(),
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Chờ xử lý',
    GhiChu NVARCHAR(255),
    CHECK (TrangThai IN (N'Chờ xử lý', N'Đã xác nhận', N'Đã giao', N'Đã hủy')),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (MaNV) REFERENCES NguoiDung(Id)
);

-- 9. Chi tiết đơn đặt hàng
CREATE TABLE ChiTietDonDatHang (
    DonDatHangChiTiet INT PRIMARY KEY IDENTITY,
    MaDonHang INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(18, 2) NOT NULL CHECK (DonGia >= 0),
    FOREIGN KEY (MaDonHang) REFERENCES DonDatHang(MaDonHang),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- 10. Hóa đơn
CREATE TABLE HoaDon (
    MaHoaDon INT PRIMARY KEY IDENTITY,
    MaDonHang INT UNIQUE,
    MaKH INT NOT NULL,
    MaNV INT NOT NULL,
    NgayXuat DATE NOT NULL DEFAULT GETDATE(),
    TongTien DECIMAL(18, 2) CHECK (TongTien >= 0),
    FOREIGN KEY (MaDonHang) REFERENCES DonDatHang(MaDonHang),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (MaNV) REFERENCES NguoiDung(Id)
);

-- 11. Chi tiết hóa đơn
CREATE TABLE ChiTietHoaDon (
    MaHDCT INT PRIMARY KEY IDENTITY,
    MaHoaDon INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    GiaBan DECIMAL(18, 2) NOT NULL CHECK (GiaBan >= 0),
    FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- 12. Lịch sử hoạt động
CREATE TABLE LichSuHoatDong (
    Id INT PRIMARY KEY IDENTITY,
    MaHoaDon INT NOT NULL,
    NguoiDungId INT NOT NULL,
    NoiDung NVARCHAR(255),
    ThoiGian DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),
    FOREIGN KEY (NguoiDungId) REFERENCES NguoiDung(Id)
);

-- 13. Công nợ
CREATE TABLE CongNo (
    MaCongNo INT PRIMARY KEY IDENTITY,
    MaHoaDon INT NOT NULL UNIQUE,
    MaNguoiGhiNhan INT NOT NULL,
    NgayGhiNhan DATE NOT NULL DEFAULT GETDATE(),
    NgayTra DATE NULL,
    SoTien DECIMAL(18,2) NOT NULL CHECK (SoTien >= 0),
    DaThanhToan BIT DEFAULT 0,
    FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),
    FOREIGN KEY (MaNguoiGhiNhan) REFERENCES NguoiDung(Id)
);

create database lt;

CREATE TABLE KhachHang
(

    id         SERIAL PRIMARY KEY,

    ma_kh      VARCHAR(20) UNIQUE NOT NULL,

    ho_ten     VARCHAR(100)       NOT NULL,

    so_du      DECIMAL(15, 2) DEFAULT 0.00,

    trang_thai VARCHAR(20)    DEFAULT 'ACTIVE',

    created_at TIMESTAMP      DEFAULT NOW()

);

-- Bảng tài khoản (3 triệu records - mỗi KH có thể nhiều TK)

CREATE TABLE TaiKhoan
(

    id            SERIAL PRIMARY KEY,

    ma_tk         VARCHAR(20) UNIQUE NOT NULL,

    khach_hang_id INTEGER REFERENCES KhachHang (id),

    so_du         DECIMAL(15, 2) DEFAULT 0.00,

    loai_tk       VARCHAR(50)    DEFAULT 'THUONG',

    trang_thai    VARCHAR(20)    DEFAULT 'ACTIVE',

    created_at    TIMESTAMP      DEFAULT NOW()

);

-- Bảng giao dịch (20 triệu records)

CREATE TABLE GiaoDich
(

    id                SERIAL PRIMARY KEY,

    ma_gd             VARCHAR(30) UNIQUE NOT NULL,

    tai_khoan_id      INTEGER REFERENCES TaiKhoan (id),

    loai_gd           VARCHAR(20)        NOT NULL, -- 'CHUYEN_TIEN', 'RUT_TIEN', 'GUI_TIEN'

    so_tien           DECIMAL(15, 2)     NOT NULL,

    tai_khoan_doi_tac INTEGER,                     -- Dùng cho chuyển tiền

    noi_dung          TEXT,

    trang_thai        VARCHAR(20) DEFAULT 'PENDING',

    created_at        TIMESTAMP   DEFAULT NOW()

);

-- Bảng lịch sử số dư

CREATE TABLE LichSuSoDu
(

    id           SERIAL PRIMARY KEY,

    tai_khoan_id INTEGER REFERENCES TaiKhoan (id),

    so_du_truoc  DECIMAL(15, 2),

    so_du_sau    DECIMAL(15, 2),

    thoi_gian    TIMESTAMP DEFAULT NOW()

);

create or replace procedure chuyen_tien(
    p_matk_ng_gui varchar(50),
    p_matk_ng_nhan varchar(50),
    p_id_ng_gui int,
    p_id_ng_nha int,
    p_so_tien decimal,
    p_noi_dung text default null
)
    language plpgsql
as
$$
declare

    v_so_du_nguon decimal;
    v_so_du_dich  decimal;
    v_ma_gd       varchar;

begin
    -- Kiểm tra tài khoản tồn tại và ACTIVE
    select tk.so_du
    into v_so_du_nguon
    from TaiKhoan tk
    where tk.ma_tk = p_matk_ng_gui
      and tk.trang_thai = 'ACTIVE';

    if not FOUND then
        raise exception 'tài khoản chưa được kích hoạt hoặc không tồn tại';
    end if;

    select tk.so_du
    into v_so_du_dich
    from TaiKhoan tk
    where tk.ma_tk = p_matk_ng_nhan
      and tk.trang_thai = 'ACTIVE';

    if not FOUND then
        raise exception 'tài khoản chưa được kích hoạt hoặc không tồn tại';
    end if;
    -- Kiểm tra số dư đủ

    select tk.so_du into v_so_du_nguon from TaiKhoan tk where tk.ma_tk = p_matk_ng_gui;
    if (v_so_du_nguon < p_so_tien) then
        raise exception 'tài khoản không đủ tiền để thực hiện giao dịch, số dư còn lại là: %', v_so_du_nguon;
    end if;

    -- Ghi nhận giao dịch
    -- Sinh mã giao dịch
    v_ma_gd := 'GD-' || TO_CHAR(NOW(), 'YYYYMMDDHH24MISS') || '-' || FLOOR(RANDOM() * 10000);
    insert into giaodich(ma_gd, tai_khoan_id, loai_gd, so_tien, tai_khoan_doi_tac, noi_dung, trang_thai)
    VALUES (v_ma_gd, p_id_ng_gui, 'Chuyen_tien', p_so_tien, p_id_ng_nha, p_noi_dung, 'SUCCESs');

    --lich su so du nguon
    insert into LichSuSoDu(tai_khoan_id, so_du_truoc, so_du_sau)
    VALUES (p_id_ng_gui, v_so_du_nguon, v_so_du_nguon - p_so_tien);
    -- Cập nhật số dư 2 tài khoản
    --cap nhat so du cho tk nguon
    update TaiKhoan set so_du = so_du - p_so_tien where taikhoan.ma_tk = p_matk_ng_gui;

    --lich su so du dich
    insert into LichSuSoDu(tai_khoan_id, so_du_truoc, so_du_sau)
    VALUES (p_id_ng_nha, v_so_du_dich, v_so_du_dich + p_so_tien);
    --update so du ng nhan
    update TaiKhoan set so_du = so_du + p_so_tien where taikhoan.ma_tk = p_matk_ng_nhan;
-- Xử lý lỗi:

exception
    when others then
        -- Rollback nếu có bất kỳ lỗi nào
        rollback;
        raise;
end;
$$;

INSERT INTO KhachHang (ma_kh, ho_ten, so_du, trang_thai, created_at)
VALUES ('KH001', 'Nguyễn Văn A', 1500000, 'ACTIVE', now()),
       ('KH002', 'Nguyễn Văn B', 2500000, 'ACTIVE', now()),
       ('KH003', 'Nguyễn Văn C', 2000000, 'BLOCKED', now());
INSERT INTO TaiKhoan (ma_tk, khach_hang_id, so_du, loai_tk, trang_thai, created_at)
VALUES ('TK001', 1, 1500000, 'THUONG', 'ACTIVE', now()),
       ('TK002', 2, 2500000, 'THUONG', 'ACTIVE', now()),
       ('TK003', 3, 2000000, 'VIP', 'BLOCKED', now());

call chuyen_tien('TK002', 'TK001', 2, 1, 500000);
-- Thực hiện trong transaction




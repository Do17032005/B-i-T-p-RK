CREATE TABLE post (
    post_id serial primary key,
    user_id int NOT NULL,
    content text,
    tags text,
    created_at timestamp DEFAULT current_timestamp,
    is_public boolean DEFAULT true
);

CREATE TABLE post_likes (
    user_id int NOT NULL,
    post_id int NOT NULL,
    liked_at timestamp DEFAULT current_timestamp,
    PRIMARY KEY (user_id, post_id)
);

INSERT INTO
    post (
        user_id,
        content,
        tags,
        created_at,
        is_public
    )
VALUES (
        1,
        'Hôm nay học SQL và index rất thú vị',
        'sql,index,study',
        '2026-03-20 08:15:00',
        true
    ),
    (
        2,
        'Chia sẻ kinh nghiệm tối ưu truy vấn PostgreSQL',
        'postgresql,performance',
        '2026-03-21 09:00:00',
        true
    ),
    (
        3,
        'Nhật ký cá nhân cuối tuần',
        'personal,weekend',
        '2026-03-21 20:10:00',
        false
    ),
    (
        4,
        'Tổng hợp kiến thức về VIEW trong CSDL',
        'sql,view,database',
        '2026-03-22 10:30:00',
        true
    ),
    (
        5,
        'Mẹo sử dụng EXPLAIN ANALYZE để đọc execution plan',
        'sql,explain,query',
        '2026-03-23 14:45:00',
        true
    ),
    (
        1,
        'Bài tập thiết kế hệ thống mạng xã hội',
        'design,system',
        '2026-03-24 19:20:00',
        true
    ),
    (
        2,
        'Test chức năng tìm kiếm không phân biệt hoa thường',
        'search,lower,content',
        '2026-03-25 07:50:00',
        true
    ),
    (
        6,
        'Chia sẻ ảnh chuyến đi biển',
        'travel,photo',
        '2026-03-25 18:05:00',
        true
    ),
    (
        7,
        'Bài viết nội bộ nhóm dự án',
        'internal,team',
        '2026-03-26 11:40:00',
        false
    ),
    (
        8,
        'Thảo luận về cấu trúc dữ liệu và thuật toán',
        'algorithm,data-structure',
        '2026-03-27 16:00:00',
        true
    );

INSERT INTO
    post_likes (user_id, post_id, liked_at)
VALUES (2, 1, '2026-03-20 09:00:00'),
    (3, 1, '2026-03-20 09:10:00'),
    (4, 1, '2026-03-20 10:25:00'),
    (1, 2, '2026-03-21 10:00:00'),
    (5, 2, '2026-03-21 10:15:00'),
    (2, 4, '2026-03-22 11:00:00'),
    (3, 4, '2026-03-22 11:05:00'),
    (1, 5, '2026-03-23 15:00:00'),
    (4, 5, '2026-03-23 15:20:00'),
    (6, 6, '2026-03-24 20:00:00'),
    (7, 6, '2026-03-24 20:05:00'),
    (8, 7, '2026-03-25 08:30:00'),
    (5, 8, '2026-03-25 18:30:00'),
    (9, 8, '2026-03-25 18:45:00'),
    (10, 10, '2026-03-27 16:30:00');

-- 1.Tối ưu hóa truy vấn tìm kiếm bài đăng công khai theo từ khóa:
-- Tạo Expression Index sử dụng LOWER(content) để tăng tốc tìm kiếm
CREATE INDEX idx_post_content_lower ON post (LOWER(content));
-- So sánh hiệu suất trước và sau khi tạo chỉ mục
EXPLAIN ANALYZE
SELECT * FROM post
WHERE is_public = true AND LOWER(content) LIKE '%sql%';




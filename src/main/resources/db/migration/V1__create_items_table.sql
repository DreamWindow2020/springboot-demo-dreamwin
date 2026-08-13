CREATE TABLE IF NOT EXISTS items (
    id          BIGSERIAL    PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

INSERT INTO items (name, description) VALUES
    ('Laptop',      'High-performance laptop with 16 GB RAM and 512 GB SSD'),
    ('Wireless Mouse', 'Ergonomic Bluetooth mouse with long battery life'),
    ('Mechanical Keyboard', 'Compact TKL keyboard with Cherry MX Blue switches'),
    ('USB-C Hub',   '7-in-1 hub with HDMI, USB 3.0, SD card, and PD charging'),
    ('Webcam',      '1080p full-HD webcam with built-in noise-cancelling mic');

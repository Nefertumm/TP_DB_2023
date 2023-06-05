CREATE TABLE employee(
    employee_id INT NOT NULL PRIMARY KEY ,
    last_name VARCHAR(20) NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    title VARCHAR(30),
    reports_to INT,
    birth_date DATE,
    hire_date DATE,
    address VARCHAR(70),
    city VARCHAR(40),
    state VARCHAR(40),
    country VARCHAR(40),
    postal_code VARCHAR(10),
    phone VARCHAR(24),
    fax VARCHAR(24),
    email VARCHAR(60)
);
CREATE TABLE customer(
    customer_id INT NOT NULL PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    company VARCHAR(80),
    address VARCHAR(70),
    city VARCHAR(40),
    state VARCHAR(40),
    country VARCHAR(40),
    postal_code VARCHAR(10),
    phone VARCHAR(24),
    fax VARCHAR(24),
    email VARCHAR(60),
    support_rep_id INT
);
CREATE TABLE invoice(
    invoice_id INT NOT NULL PRIMARY KEY,
    customer_id INT NOT NULL,
    invoice_date DATE NOT NULL,
    billing_address VARCHAR(70),
    billing_city VARCHAR(40),
    billing_state VARCHAR(40),
    billing_country VARCHAR(40),
    billing_postal_code VARCHAR(10),
    total DECIMAL(10,2) NOT NULL
);
CREATE TABLE invoice_line(
    invoice_line_id INT NOT NULL PRIMARY KEY,
    invoice_id INT NOT NULL,
    track_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL
);
CREATE TABLE track(
    track_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    album_id INT,
    media_type_id INT NOT NULL,
    genre_id INT,
    composer VARCHAR(220),
    milliseconds INT NOT NULL,
    bytes INT,
    unit_price DECIMAL(10,2) NOT NULL
);
CREATE TABLE album(
    album_id INT NOT NULL PRIMARY KEY,
    title VARCHAR(160) NOT NULL,
    artist_id INT NOT NULL
);
CREATE TABLE artist(
    artist_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(120)
);
CREATE TABLE genre(
    genre_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(120)
);
CREATE TABLE media_type(
    media_type_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(120)
);
CREATE TABLE playlist(
    playlist_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(120)
);
CREATE TABLE playlist_track(
    playlist_id INT NOT NULL
        CONSTRAINT "FK_playlist_track_playlist_id" REFERENCES "playlist" ,
    track_id INT NOT NULL,
        CONSTRAINT "FK_playlist_track_track_id" REFERENCES "track",
    CONSTRAINT "PK_playlist_track" 
        PRIMARY KEY (playlist_id, track_id)
);

ALTER TABLE employee
    ADD CONSTRAINT "FK_employee_reports_to"
        FOREIGN KEY (report_to)
        REFERENCES employee(employee_id);
ALTER TABLE customer
    ADD CONSTRAINT "FK_customer_support_rep_id"
        FOREIGN KEY (support_rep_id)
        REFERENCES employee(employee_id);
ALTER TABLE invoice
    ADD CONSTRAINT "FK_invoice_customer_id"
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id);
ALTER TABLE invoice_line
    ADD CONSTRAINT "FK_invoice_line_invoice_id"
        FOREIGN KEY (invoice_id)
        REFERENCES invoice(invoice_id),
    ADD CONSTRAINT "FK_invoice_line_track_id"
        FOREIGN KEY (track_id)
        REFERENCES track(track_id);
ALTER TABLE track
    ADD CONSTRAINT "FK_track_album_id"
        FOREIGN KEY (album_id)
        REFERENCES album(album_id),
    ADD CONSTRAINT "FK_track_genre_id"
        FOREIGN KEY (genre_id)
        REFERENCES genre(genre_id),
    ADD CONSTRAINT "FK_track_media_type_id"
        FOREIGN KEY (media_type_id)
        REFERENCES media_type(media_type_id);
ALTER TABLE album
    ADD CONSTRAINT "FK_album_artist_id"
        FOREIGN KEY (artist_id)
        REFERENCES artist(artist_id);
ALTER TABLE playlist_track
    ADD CONSTRAINT "FK_playlist_track_playlist_id"
        FOREIGN KEY (playlist_id)
        REFERENCES playlist(playlist_id),
    ADD CONSTRAINT "FK_playlist_track_track_id"
        FOREIGN KEY (track_id)
        REFERENCES track(track_id);
```
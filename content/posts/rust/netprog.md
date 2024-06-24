---
title: "通过 Rust 学习网络编程"
subtitle:
date: 2024-06-24T18:35:26+08:00
# draft: true
# author:
#   name:
#   link:
#   email:
#   avatar:
description:
keywords:
license:
comment: false
weight: 0
tags:
  - Rust
  - Sysprog
  - Network
categories:
  - Rust
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
summary:
resources:
  - name: featured-image
    src: featured-image.jpg
  - name: featured-image-preview
    src: featured-image-preview.jpg
toc: true
math: true
lightgallery: true
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

<!--more-->

- {{< link href="https://www.bilibili.com/video/BV1b54y1X7my/" content="教学录影" external-icon=true >}}

## TCP Server/Client

{{< image src="/images/rust/tcp-server-client.drawio.svg" caption="TCP C/S" >}}

Server: 

```rs
fn handle_client(mut stream: TcpStream) -> io::Result<()> {
    let mut buf = [0; 512];
    for _ in 0..1000 {
        let bytes_read = stream.read(&mut buf)?;
        if bytes_read == 0 {
            return Ok(());
        }

        stream.write(&buf[..bytes_read])?;
        thread::sleep(Duration::from_secs(1));
    }
    Ok(())
}

fn main() -> io::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:8080")?;
    println!("TCP Server is running...");

    for stream in listener.incoming() {
        let stream = stream.expect("failed");
        thread::spawn(move || {
            handle_client(stream).unwrap_or_else(|error| eprintln!("{}", error));
        });
    }
    Ok(())
}
```

- method [std::net::TcpListener::bind](https://doc.rust-lang.org/std/net/struct.TcpListener.html#method.bind)
- method [std::net::TcpListener::incoming](https://doc.rust-lang.org/std/net/struct.TcpListener.html#method.incoming)

Client:

```rs
fn main() -> io::Result<()> {
    let mut stream = TcpStream::connect("127.0.0.1:8080")?;
    println!("TCP Client is running...");

    for _ in 0..10 {
        let mut input = String::new();
        io::stdin().read_line(&mut input).expect("Failed to read");
        stream.write(input.as_bytes()).expect("Failed to write");

        let mut reader = BufReader::new(&stream);
        let mut buffer = vec![];
        reader
            .read_until(b'\n', &mut buffer)
            .expect("Failed to read");
        println!(
            "Read from server: {}",
            std::str::from_utf8(&buffer).expect("Failed to accept")
        );
    }
    Ok(())
}
```

- method [std::net::TcpStream::connect](https://doc.rust-lang.org/std/net/struct.TcpStream.html#method.connect)

## UDP Server/Client

Server:

```rs
fn main() -> io::Result<()> {
    let socket = UdpSocket::bind("127.0.0.1:8080")?;
    println!("UDP socket is running...");

    loop {
        let mut buf = [0; 1500];
        let (amt, src) = socket.recv_from(&mut buf)?;

        let buf = &mut buf[..amt];
        buf.reverse();
        socket.send_to(buf, src)?;
    }
}
```

- method [std::net::UdpSocket::bind](https://doc.rust-lang.org/std/net/struct.UdpSocket.html#method.bind)
- method [std::net::UdpSocket::recv_from](https://doc.rust-lang.org/std/net/struct.UdpSocket.html#method.recv_from)
- method [std::net::UdpSocket::send_to](https://doc.rust-lang.org/std/net/struct.UdpSocket.html#method.send_to)

Client:

```rs
fn main() -> io::Result<()> {
    let socket = UdpSocket::bind("127.0.0.1:8081")?;
    println!("UDP socket is running...");
    socket.connect("127.0.0.1:8080")?;

    loop {
        let mut input = String::new();
        io::stdin().read_line(&mut input)?;
        socket.send(input.as_bytes())?;

        let mut buf = [0; 1500];
        let bytes_read = socket.recv(&mut buf)?;
        println!(
            "Receive: {}",
            std::str::from_utf8(&buf[..bytes_read]).expect("Invaild message")
        );
    }
}
```

- method [std::net::UdpSocket::connect](https://doc.rust-lang.org/std/net/struct.UdpSocket.html#method.connect)
- method [std::net::UdpSocket::send](https://doc.rust-lang.org/std/net/struct.UdpSocket.html#method.send)
- method [std::net::UdpSocket::recv](https://doc.rust-lang.org/std/net/struct.UdpSocket.html#method.recv)

## Homework

{{< admonition info >}}
- [ ] [Building a DNS server in Rust](https://github.com/EmilHernvall/dnsguide/tree/master)
- Brown: [CSCI1680: Computer Networks](https://cs.brown.edu/courses/csci1680/f22/schedule/)
{{< /admonition >}}

## Documentations

这里列举视频中一些概念相关的 documentation 

> 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

- Module [std::net](https://doc.rust-lang.org/std/net/index.html)
  - Struct [std::net::TcpListener](https://doc.rust-lang.org/std/net/struct.TcpListener.html)
  - Struct [std::net::TcpStream](https://doc.rust-lang.org/std/net/struct.TcpStream.html)
  - Struct [std::net::UdpSocket](https://doc.rust-lang.org/std/net/struct.UdpSocket.html)

- Trait [std::io::Read](https://doc.rust-lang.org/std/io/trait.Read.html)
- Trait [std::io::Write](https://doc.rust-lang.org/std/io/trait.Write.html)
- Trait [std::io::BufRead](https://doc.rust-lang.org/std/io/trait.BufRead.html#method.read_until)
  - method [std::io::BufRead::read_until](https://doc.rust-lang.org/std/io/trait.BufRead.html#method.read_until)

- Function [std::io::stdin](https://doc.rust-lang.org/std/io/fn.stdin.html)
- Function [std::thread\::sleep](https://doc.rust-lang.org/std/thread/fn.sleep.html)
- Function [std::str::from_utf8](https://doc.rust-lang.org/std/str/fn.from_utf8.html)

- Struct [std::time::Duration](https://doc.rust-lang.org/std/time/struct.Duration.html)

- method [str::as_bytes](https://doc.rust-lang.org/std/primitive.str.html#method.as_bytes)


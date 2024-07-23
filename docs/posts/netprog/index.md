# 通过 Rust 学习网络编程


&lt;!--more--&gt;

- {{&lt; link href=&#34;https://www.bilibili.com/video/BV1b54y1X7my/&#34; content=&#34;教学录影&#34; external-icon=true &gt;}}

## TCP Server/Client

{{&lt; image src=&#34;/images/rust/tcp-server-client.drawio.svg&#34; caption=&#34;TCP C/S&#34; &gt;}}

Server: 

```rs
fn handle_client(mut stream: TcpStream) -&gt; io::Result&lt;()&gt; {
    let mut buf = [0; 512];
    for _ in 0..1000 {
        let bytes_read = stream.read(&amp;mut buf)?;
        if bytes_read == 0 {
            return Ok(());
        }

        stream.write(&amp;buf[..bytes_read])?;
        thread::sleep(Duration::from_secs(1));
    }
    Ok(())
}

fn main() -&gt; io::Result&lt;()&gt; {
    let listener = TcpListener::bind(&#34;127.0.0.1:8080&#34;)?;
    println!(&#34;TCP Server is running...&#34;);

    for stream in listener.incoming() {
        let stream = stream.expect(&#34;failed&#34;);
        thread::spawn(move || {
            handle_client(stream).unwrap_or_else(|error| eprintln!(&#34;{}&#34;, error));
        });
    }
    Ok(())
}
```

- method [std::net::TcpListener::bind](https://doc.rust-lang.org/std/net/struct.TcpListener.html#method.bind)
- method [std::net::TcpListener::incoming](https://doc.rust-lang.org/std/net/struct.TcpListener.html#method.incoming)

Client:

```rs
fn main() -&gt; io::Result&lt;()&gt; {
    let mut stream = TcpStream::connect(&#34;127.0.0.1:8080&#34;)?;
    println!(&#34;TCP Client is running...&#34;);

    for _ in 0..10 {
        let mut input = String::new();
        io::stdin().read_line(&amp;mut input).expect(&#34;Failed to read&#34;);
        stream.write(input.as_bytes()).expect(&#34;Failed to write&#34;);

        let mut reader = BufReader::new(&amp;stream);
        let mut buffer = vec![];
        reader
            .read_until(b&#39;\n&#39;, &amp;mut buffer)
            .expect(&#34;Failed to read&#34;);
        println!(
            &#34;Read from server: {}&#34;,
            std::str::from_utf8(&amp;buffer).expect(&#34;Failed to accept&#34;)
        );
    }
    Ok(())
}
```

- method [std::net::TcpStream::connect](https://doc.rust-lang.org/std/net/struct.TcpStream.html#method.connect)

## UDP Server/Client

{{&lt; image src=&#34;/images/rust/udp-server-client.drawio.svg&#34; caption=&#34;UDP C/S&#34; &gt;}}

Server:

```rs
fn main() -&gt; io::Result&lt;()&gt; {
    let socket = UdpSocket::bind(&#34;127.0.0.1:8080&#34;)?;
    println!(&#34;UDP socket is running...&#34;);

    loop {
        let mut buf = [0; 1500];
        let (amt, src) = socket.recv_from(&amp;mut buf)?;

        let buf = &amp;mut buf[..amt];
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
fn main() -&gt; io::Result&lt;()&gt; {
    let socket = UdpSocket::bind(&#34;127.0.0.1:8081&#34;)?;
    println!(&#34;UDP socket is running...&#34;);
    socket.connect(&#34;127.0.0.1:8080&#34;)?;

    loop {
        let mut input = String::new();
        io::stdin().read_line(&amp;mut input)?;
        socket.send(input.as_bytes())?;

        let mut buf = [0; 1500];
        let bytes_read = socket.recv(&amp;mut buf)?;
        println!(
            &#34;Receive: {}&#34;,
            std::str::from_utf8(&amp;buf[..bytes_read]).expect(&#34;Invaild message&#34;)
        );
    }
}
```

- method [std::net::UdpSocket::connect](https://doc.rust-lang.org/std/net/struct.UdpSocket.html#method.connect)
- method [std::net::UdpSocket::send](https://doc.rust-lang.org/std/net/struct.UdpSocket.html#method.send)
- method [std::net::UdpSocket::recv](https://doc.rust-lang.org/std/net/struct.UdpSocket.html#method.recv)

## IP/Socket Address

- Enum [std::net::IpAddr](https://doc.rust-lang.org/std/net/enum.IpAddr.html)
- Enum [std::net::SocketAddr](https://doc.rust-lang.org/std/net/enum.SocketAddr.html)
- Enum [ipnet::IpNet](https://docs.rs/ipnet/latest/ipnet/enum.IpNet.html)

## Homework

{{&lt; admonition info &gt;}}
- [ ] [Building a DNS server in Rust](https://github.com/EmilHernvall/dnsguide/tree/master)
- Brown: [CSCI1680: Computer Networks](https://cs.brown.edu/courses/csci1680/f22/schedule/)
{{&lt; /admonition &gt;}}

## Documentations

这里列举视频中一些概念相关的 documentation 

&gt; 学习的一手资料是官方文档，请务必自主学会阅读规格书之类的资料

### Crate [std](https://doc.rust-lang.org/std/index.html) 

- Module [std::net](https://doc.rust-lang.org/std/net/index.html)
  - Struct [std::net::TcpListener](https://doc.rust-lang.org/std/net/struct.TcpListener.html)
  - Struct [std::net::TcpStream](https://doc.rust-lang.org/std/net/struct.TcpStream.html)
  - Struct [std::net::UdpSocket](https://doc.rust-lang.org/std/net/struct.UdpSocket.html)
  - Enum [std::net::IpAddr](https://doc.rust-lang.org/std/net/enum.IpAddr.html)
  - Enum [std::net::SocketAddr](https://doc.rust-lang.org/std/net/enum.SocketAddr.html)

- Trait [std::io::Read](https://doc.rust-lang.org/std/io/trait.Read.html)
- Trait [std::io::Write](https://doc.rust-lang.org/std/io/trait.Write.html)
- Trait [std::io::BufRead](https://doc.rust-lang.org/std/io/trait.BufRead.html#method.read_until)
  - method [std::io::BufRead::read_until](https://doc.rust-lang.org/std/io/trait.BufRead.html#method.read_until)

- Function [std::io::stdin](https://doc.rust-lang.org/std/io/fn.stdin.html)
- Function [std::thread\::sleep](https://doc.rust-lang.org/std/thread/fn.sleep.html)
- Function [std::str::from_utf8](https://doc.rust-lang.org/std/str/fn.from_utf8.html)

- Struct [std::time::Duration](https://doc.rust-lang.org/std/time/struct.Duration.html)

- method [str::as_bytes](https://doc.rust-lang.org/std/primitive.str.html#method.as_bytes)

### Crate [ipnet](https://docs.rs/ipnet/latest/ipnet/)

- Enum [ipnet::IpNet](https://docs.rs/ipnet/latest/ipnet/enum.IpNet.html)
- Struct [ipnet::Ipv4Net](https://docs.rs/ipnet/latest/ipnet/struct.Ipv4Net.html)
- Struxt [ipnet::Ipv6Net](https://docs.rs/ipnet/latest/ipnet/struct.Ipv6Net.html)



---

> 作者: [ccrysisa](https://github.com/ccrysisa)  
> URL: https://ccrysisa.github.io/posts/netprog/  


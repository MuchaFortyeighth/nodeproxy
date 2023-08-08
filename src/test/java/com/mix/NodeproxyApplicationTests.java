package com.mix;

import com.mix.proxy.ProxyServer;
import io.netty.channel.ChannelFuture;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Scanner;

@SpringBootTest
class NodeproxyApplicationTests {

	@Test
	void contextLoads() throws Exception{

	}

	public static void main(String[] args) throws Exception{
		ProxyServer proxyServer = new ProxyServer(9999,"contracts.cwjometyyo6e.rds.cn-northwest-1.amazonaws.com.cn",3306,"mysql");
		ChannelFuture init = proxyServer.init();
		try {
			init.sync();
			new Thread(()->{
				Scanner scanner = new Scanner(System.in);
				while (true){
					String line = scanner.nextLine();
					if ("Q".equals(line)){
						init.channel().close();
						break;
					} else {
						init.channel().writeAndFlush(line);
					}
				}
			},"input").start();
			init.channel().closeFuture().sync();
		} finally {
			init.channel().closeFuture().sync();
		}
	}

}

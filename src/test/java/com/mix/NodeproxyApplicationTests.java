package com.mix;

import com.alibaba.fastjson.JSONObject;
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

//	public static void main(String[] args) throws Exception{
//		ProxyServer proxyServer = new ProxyServer(9999,"contracts.cwjometyyo6e.rds.cn-northwest-1.amazonaws.com.cn",3306,"mysql");
//		ChannelFuture init = proxyServer.init();
//		try {
//			init.sync();
//			new Thread(()->{
//				Scanner scanner = new Scanner(System.in);
//				while (true){
//					String line = scanner.nextLine();
//					if ("Q".equals(line)){
//						init.channel().close();
//						break;
//					} else {
//						init.channel().writeAndFlush(line);
//					}
//				}
//			},"input").start();
//			init.channel().closeFuture().sync();
//		} finally {
//			init.channel().closeFuture().sync();
//		}
//	}

	public static void main(String[] args) {
		Object bodyContent = "{\"timeStamp\":\"20230718114745\",\"transIDO\":\"e53b209562914cb8845763be8760aed2\",\"sessionID\":\"e53b209562914cb8845763be8760aed2\",\"sign\":\"359219FCBA9D300C4E1E54503A7F2C1D\",\"envFlag\":\"0\",\"accessToken\":\"20230814100000b24c341cf0ab4635ae3815df98284358-0019-1689386400\",\"version\":\"1.0.0\",\"signMethod\":\"md5\",\"content\":\"{\\\"orderSourceID\\\":\\\"2\\\",\\\"orderInfo\\\":{\\\"businessMode\\\":\\\"1\\\",\\\"sICode\\\":\\\"03\\\",\\\"finishTime\\\":\\\"20230718114448\\\",\\\"notes\\\":\\\"\\\",\\\"busNeedDegree\\\":\\\"4\\\",\\\"poAttachment\\\":[{\\\"poAttType\\\":\\\"2\\\",\\\"poAttName\\\":\\\"000A230718138806001_50004020011_20230718114448.xlsx\\\"},{\\\"contEffdate\\\":\\\"20230701\\\",\\\"autoRecontCyc\\\":\\\"请选择\\\",\\\"contFee\\\":\\\"qqq\\\",\\\"isAutoRecont\\\":\\\"0\\\",\\\"poAttCode\\\":\\\"791A791951005542\\\",\\\"perferPlan\\\":\\\"qq\\\",\\\"poAttType\\\":\\\"1\\\",\\\"contName\\\":\\\"791A791951005542\\\",\\\"contExpdate\\\":\\\"20231231\\\",\\\"isRecont\\\":\\\"0\\\",\\\"poAttName\\\":\\\"000A230718138806001_agreement_20230718114449.xlsx\\\"}],\\\"poOrderRatePlans\\\":[],\\\"productOrders\\\":[{\\\"productOrderCharge\\\":[{\\\"productOrderChargeValue\\\":\\\"0\\\",\\\"productOrderChargeCode\\\":\\\"1063\\\"}],\\\"productOrderBusinesses\\\":{\\\"operationSubTypeID\\\":\\\"1\\\"},\\\"productOrder\\\":{\\\"productID\\\":\\\"60000530401\\\",\\\"siCode\\\":\\\"03\\\",\\\"productOrderNumber\\\":\\\"000A230718138806001\\\",\\\"productSpecNumber\\\":\\\"5000402\\\"},\\\"productOrderRatePlans\\\":[{\\\"ratePlanType\\\":\\\"1\\\",\\\"parameter\\\":[{\\\"parameterNumber\\\":\\\"000263201\\\",\\\"parameterName\\\":\\\"d\\\",\\\"parameterValue\\\":\\\"80\\\"}],\\\"ratePlanID\\\":\\\"2632\\\",\\\"action\\\":\\\"1\\\",\\\"description\\\":\\\"流量阶梯套餐：0GB-10TB（含)单价0.18元/GB/月；10TB-50TB（含)单价0.17元/GB/月；50TB-100TB（含）单价0.16元/GB/月；100TB-1PB（含）单价0.14元/GB/月；大于1PB单价0.11元/GB/月\\\"},{\\\"ratePlanType\\\":\\\"1\\\",\\\"parameter\\\":[{\\\"parameterNumber\\\":\\\"0004127001\\\",\\\"parameterName\\\":\\\"x\\\",\\\"parameterValue\\\":\\\"10\\\"}],\\\"ratePlanID\\\":\\\"4127\\\",\\\"action\\\":\\\"1\\\",\\\"description\\\":\\\"100GB年包13元，最低折扣价10元\\\"}],\\\"productOrderCharacters\\\":[{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020001\\\",\\\"name\\\":\\\"关联的试用申请单\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"000A230718138803001\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020002\\\",\\\"name\\\":\\\"期望开通计费时间\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"20230718\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020005\\\",\\\"name\\\":\\\"业务计费方式\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"1\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020026\\\",\\\"name\\\":\\\"产品类型\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"1\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020006\\\",\\\"name\\\":\\\"业务类型\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"1\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020008\\\",\\\"name\\\":\\\"业务量峰值带宽预测（Gbps）\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"1111\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020011\\\",\\\"name\\\":\\\"合同附件\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"工作簿1.xlsx\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020023\\\",\\\"name\\\":\\\"业务量保底值\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020029\\\",\\\"name\\\":\\\"开通域名\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"www.12345.com\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020025\\\",\\\"name\\\":\\\"带宽和流量换算进率\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"1024\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020032\\\",\\\"name\\\":\\\"是否TOP55客户\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"0\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020037\\\",\\\"name\\\":\\\"是否省公司本地客户\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"0\\\"},{\\\"characterGroup\\\":\\\"SL\\\",\\\"productSpecCharacterNumber\\\":\\\"50004020036\\\",\\\"name\\\":\\\"是否错峰类客户\\\",\\\"action\\\":\\\"1\\\",\\\"characterValue\\\":\\\"0\\\"}]}],\\\"poOrderNumber\\\":\\\"000A230718138806\\\",\\\"poRatePolicyEffRule\\\":\\\"1\\\",\\\"productOfferingID\\\":\\\"30000223776\\\",\\\"timeStamp\\\":\\\"20230718114448\\\",\\\"poOrderBusinesses\\\":{\\\"operationSubTypeID\\\":\\\"7\\\"},\\\"poAudit\\\":[{\\\"auditTime\\\":\\\"20230718114224\\\",\\\"auditor\\\":\\\"订单创建\\\",\\\"auditDesc\\\":\\\"订单创建\\\"},{\\\"auditTime\\\":\\\"20230718114225\\\",\\\"auditor\\\":\\\"政企CDN业务管理员\\\",\\\"auditDesc\\\":\\\"44545\\\"},{\\\"auditTime\\\":\\\"20230718114304\\\",\\\"auditor\\\":\\\"总部领导审批\\\",\\\"auditDesc\\\":\\\"46446767\\\"},{\\\"auditTime\\\":\\\"20230718114339\\\",\\\"auditor\\\":\\\"接口类型\\\",\\\"auditDesc\\\":\\\"接口类型\\\"},{\\\"auditTime\\\":\\\"20230718114340\\\",\\\"auditor\\\":\\\"CDN业务受理同步\\\",\\\"auditDesc\\\":\\\"CDN业务受理同步\\\"},{\\\"auditTime\\\":\\\"20230718114407\\\",\\\"auditor\\\":\\\"CDN平台反馈挂起\\\",\\\"auditDesc\\\":\\\"订单已经送平台，等待平台进一步反馈\\\"},{\\\"auditTime\\\":\\\"20230718114440\\\",\\\"auditor\\\":\\\"CDN开通成功反馈\\\",\\\"auditDesc\\\":\\\"资源开通成功\\\"},{\\\"auditTime\\\":\\\"20230718114440\\\",\\\"auditor\\\":\\\"成功归档\\\",\\\"auditDesc\\\":\\\"执行成功归档流程\\\"}],\\\"hostCompany\\\":\\\"000\\\",\\\"busiOpportNumber\\\":\\\"\\\",\\\"poOrderCharge\\\":[],\\\"contactorInfo\\\":[{\\\"contactorName\\\":\\\"111\\\",\\\"contactorType\\\":\\\"2\\\",\\\"contactorPhone\\\":\\\"13233334444\\\"},{\\\"contactorName\\\":\\\"超级管理员\\\",\\\"contactorType\\\":\\\"5\\\",\\\"contactorPhone\\\":\\\"15822412241\\\",\\\"staffNumber\\\":\\\"000admin\\\"},{\\\"contactorName\\\":\\\"-\\\",\\\"contactorType\\\":\\\"4\\\",\\\"contactorPhone\\\":\\\"-\\\"}],\\\"poSpecNumber\\\":\\\"50004\\\"},\\\"customerNumber\\\":\\\"791A791951005542\\\"}\",\"domain\":\"COP\",\"routeType\":\"00\",\"routeValue\":\"220\",\"busType\":\"BBSS\"}";
		System.out.println(bodyContent.toString());
		System.out.println(String.valueOf(bodyContent));


		JSONObject jsonObject = JSONObject.parseObject(String.valueOf(bodyContent));
		JSONObject contentJson = JSONObject.parseObject(jsonObject.getString("content"));
//		AppPreOrderVo appPreOrderVo = contentJson.toJavaObject(AppPreOrderVo.Class);
		System.out.println(contentJson);
	}

}

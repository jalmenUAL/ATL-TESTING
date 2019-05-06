package tester;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.PrintWriter;

import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQException;
import javax.xml.xquery.XQExpression;
import javax.xml.xquery.XQSequence;

import net.xqj.basex.BaseXXQDataSource;

public class Running {

public static void main(String[] args)
{
	
	XQDataSource ds = new BaseXXQDataSource();

    try {
		ds.setLogWriter(new PrintWriter(System.out, true));
	} catch (XQException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

    try {
		ds.setProperty("serverName", "localhost");
	} catch (XQException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    try {
		ds.setProperty("port", "1984");
	} catch (XQException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    try {
		ds.setProperty("user", "admin");
	} catch (XQException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    try {
		ds.setProperty("password", "admin");
	} catch (XQException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	XQConnection xqc = null;
	try {
		xqc = ds.getConnection();
	} catch (XQException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	InputStream query = null;
	try {
		query = new FileInputStream("C:/Users/Admin/workspace-atl/ATL_tester/TESTING/Test_Cases_ECore.xq");
	} catch (FileNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	XQExpression xqe = null;
	XQSequence xqs = null;
	try {
		xqe = xqc.createExpression();
	} catch (XQException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	try {
		xqs = xqe.executeQuery(query);
	} catch (XQException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	try {
		while (xqs.next()) {
			System.out.println("Y otro");
		    System.out.println(xqs.getItemAsString(null));
		  }
	} catch (XQException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
}
	
	
}

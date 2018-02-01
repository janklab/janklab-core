package net.janklab.mdbc;

import java.sql.Connection;

/**
 * A JLConnection is a thin wrapper around a java.sql.Connection object, with some additional 
 * metadata and functionality.
 * 
 * In particular, JLConnection holds on to the original URL and connection properties so the 
 * connection can be identified WRT its host in a human-readable manner.
 * 
 * @author janke
 */
public class JLConnection {
  
  public final Connection jdbcConn;
  public final String user;
  public final String baseUrl;
  
  public JLConnection(Connection jdbcConn, String baseUrl, String user) {
    this.jdbcConn = jdbcConn;
    this.baseUrl = baseUrl;
    this.user = user;
  }
  
  @Override
  public String toString() {
    return "JLConnection: " + baseUrl + " user=" + user + " conn=" + jdbcConn;
  }
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.janklab.util;

/**
 * A utility class for Reflection-related operations.
 */
public class Reflection {

  /**
   * Calls {@code Class.forName}. This is needed because Class.forName() needs be invoked from one
   * of the classes inside the classloader for Matlab's dynamic Java path if you want it to see all
   * the loaded classes.
   *
   * @param name Name of the class to look up.
   * @return The Class metaclass for the named class.
   * @throws ClassNotFoundException
   */
  public static Class classForName(String name) throws ClassNotFoundException {
    return Class.forName(name);
  }

  public static void helloWorld() {
    System.out.println("Hello, world!");
  }
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.easysmarthouse.provider.device;

/**
 * @author rusakovich
 */
public enum DeviceType {

    Sensor,
    Actuator,
    Branch,
    Key,
    Unknown;

    @Override
    public String toString() {
        return String.valueOf(this.ordinal());
    }
}

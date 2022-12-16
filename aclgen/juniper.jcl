firewall {
    family inet {
        replace:
        /*
        ** $Id:$
        ** $Date:$
        ** $Revision:$
        **
        ** edge input filter for sample network.
        */
        filter edge-inbound {
            interface-specific;
            term deny-from-bogons {
                from {
                    source-address {
                        0.0.0.0/8;
                        192.0.0.0/24;
                        192.0.2.0/24;
                        198.18.0.0/15;
                        198.51.100.0/24;
                        203.0.113.0/24;
                        /* IP multicast */
                        224.0.0.0/4;
                        240.0.0.0/4;
                    }
                }
                then {
                    discard;
                }
            }
            term deny-from-reserved {
                from {
                    source-address {
                        /* reserved */
                        0.0.0.0/8;
                        /* non-public */
                        10.0.0.0/8;
                        /* Shared Address Space */
                        100.64.0.0/10;
                        /* loopback */
                        127.0.0.0/8;
                        /* special use IPv4 addresses - netdeploy */
                        169.254.0.0/16;
                        /* non-public */
                        172.16.0.0/12;
                        /* non-public */
                        192.168.0.0/16;
                        /* IP multicast */
                        224.0.0.0/4;
                        240.0.0.0/4;
                    }
                }
                then {
                    discard;
                }
            }
            term deny-to-rfc1918 {
                from {
                    destination-address {
                        /* non-public */
                        10.0.0.0/8;
                        /* non-public */
                        172.16.0.0/12;
                        /* non-public */
                        192.168.0.0/16;
                    }
                }
                then {
                    discard;
                }
            }
            term discard-spoofs {
                from {
                    source-address {
                        /* non-public */
                        10.0.0.0/8;
                        /* non-public */
                        172.16.0.0/12;
                        /* non-public */
                        192.168.0.0/16;
                    }
                }
                then {
                    discard;
                }
            }
            term permit-ipsec-access {
                from {
                    source-address {
                        /* Example REMOTE OFFICES */
                        10.100.0.0/24;
                        192.17.1.0/24;
                    }
                    destination-address {
                        /* VPN HUB */
                        10.100.1.0/24;
                    }
                    protocol 50;
                }
                then accept;
            }
            term permit-ike-access {
                from {
                    source-address {
                        /* Example REMOTE OFFICES */
                        10.100.0.0/24;
                        192.17.1.0/24;
                    }
                    destination-address {
                        /* VPN HUB */
                        10.100.1.0/24;
                    }
                    protocol udp;
                    destination-port 500;
                }
                then accept;
            }
            term permit-public-web-access {
                from {
                    destination-address {
                        /* Example web server 1 */
                        200.1.1.1/32;
                        /* Example web server 2 */
                        200.1.1.2/32;
                    }
                    protocol tcp;
                    destination-port [ 80 443 8080 ];
                }
                then accept;
            }
            term permit-tcp-replies {
                from {
                    protocol tcp;
                    tcp-established;
                }
                then accept;
            }
            term default-deny {
                then {
                    discard;
                }
            }
        }
    }
}
firewall {
    family inet {
        replace:
        /*
        ** $Id:$
        ** $Date:$
        ** $Revision:$
        **
        ** edge output filter for sample network.
        */
        filter edge-outbound {
            interface-specific;
            term drop-internal-sourced-outbound {
                from {
                    destination-address {
                        /* reserved */
                        0.0.0.0/8;
                        /* non-public */
                        10.0.0.0/8;
                        /* non-public */
                        10.0.0.0/8;
                        /* Shared Address Space */
                        100.64.0.0/10;
                        /* loopback */
                        127.0.0.0/8;
                        /* special use IPv4 addresses - netdeploy */
                        169.254.0.0/16;
                        /* non-public */
                        172.16.0.0/12;
                        /* non-public */
                        172.16.0.0/12;
                        /* non-public */
                        192.168.0.0/16;
                        /* non-public */
                        192.168.0.0/16;
                        /* IP multicast */
                        224.0.0.0/4;
                        240.0.0.0/4;
                    }
                }
                then {
                    discard;
                }
            }
            term reject-internal {
                from {
                    source-address {
                        /* non-public */
                        10.0.0.0/8;
                        /* non-public */
                        172.16.0.0/12;
                        /* non-public */
                        192.168.0.0/16;
                    }
                }
                then {
                    reject;
                }
            }
            term default-accept {
                then accept;
            }
        }
    }
}

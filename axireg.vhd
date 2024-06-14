-- #############################################################################
-- AXI3 simple slave peripheral register
-- #############################################################################

-- Missing and ToDO
--  * does not handle bursts
--  * does not handle unaligned writes/reads
--  * does not handle non 32-Bit writes
--  * Statemachines are not Medwedew, therefore AXI signals not from registers
--  * Does not check address. This will accept all transactions

library ieee;
use ieee.std_logic_1164.all;

entity axireg is
port(
  clk               : in   std_ulogic;
  rst_n             : in   std_ulogic;
  axi_slave_awid    : in   std_ulogic_vector(11 downto 0);
  axi_slave_awaddr  : in   std_ulogic_vector(20 downto 0);
  axi_slave_awlen   : in   std_ulogic_vector(3 downto 0);
  axi_slave_awsize  : in   std_ulogic_vector(2 downto 0);
  axi_slave_awburst : in   std_ulogic_vector(1 downto 0);
  axi_slave_awlock  : in   std_ulogic_vector(1 downto 0);
  axi_slave_awcache : in   std_ulogic_vector(3 downto 0);
  axi_slave_awprot  : in   std_ulogic_vector(2 downto 0);
  axi_slave_awvalid : in   std_ulogic;
  axi_slave_awready : out  std_ulogic;
  axi_slave_wid     : in   std_ulogic_vector(11 downto 0);
  axi_slave_wdata   : in   std_ulogic_vector(31 downto 0);
  axi_slave_wstrb   : in   std_ulogic_vector(3 downto 0);
  axi_slave_wlast   : in   std_ulogic;
  axi_slave_wvalid  : in   std_ulogic;
  axi_slave_wready  : out  std_ulogic;
  axi_slave_bid     : out  std_ulogic_vector(11 downto 0);
  axi_slave_bresp   : out  std_ulogic_vector(1 downto 0);
  axi_slave_bvalid  : out  std_ulogic;
  axi_slave_bready  : in   std_ulogic;
  axi_slave_arid    : in   std_ulogic_vector(11 downto 0);
  axi_slave_araddr  : in   std_ulogic_vector(20 downto 0);
  axi_slave_arlen   : in   std_ulogic_vector(3 downto 0);
  axi_slave_arsize  : in   std_ulogic_vector(2 downto 0);
  axi_slave_arburst : in   std_ulogic_vector(1 downto 0);
  axi_slave_arlock  : in   std_ulogic_vector(1 downto 0);
  axi_slave_arcache : in   std_ulogic_vector(3 downto 0);
  axi_slave_arprot  : in   std_ulogic_vector(2 downto 0);
  axi_slave_arvalid : in   std_ulogic;
  axi_slave_arready : out  std_ulogic;
  axi_slave_rid     : out  std_ulogic_vector(11 downto 0);
  axi_slave_rdata   : out  std_ulogic_vector(31 downto 0);
  axi_slave_rresp   : out  std_ulogic_vector(1 downto 0);
  axi_slave_rlast   : out  std_ulogic;
  axi_slave_rvalid  : out  std_ulogic;
  axi_slave_rready  : in   std_ulogic;
  led_o             : out  std_ulogic_vector(9 downto 0)
);
end entity axireg;

architecture rtl of axireg is
  type wstate_t is (AXIW_IDLE, AXIW_ADDR_RECEIVED, AXIW_DATA_RECEIVED, AXIW_RESPONSE, AXIW_RESPONSE_WAIT);
  signal cwstate, nwstate : wstate_t;
  signal reg : std_ulogic_vector(31 downto 0);
  signal reg_en : std_ulogic;
  signal awid : std_ulogic_vector(axi_slave_awid'range);
  signal waddr : std_ulogic_vector(3 downto 0);
  signal waddr_en : std_ulogic;
  signal wdata : std_ulogic_vector(axi_slave_wdata'range);
  signal wdata_en : std_ulogic;
  type rstate_t is (AXIR_IDLE, AXIR_RESPONSE);
  signal crstate, nrstate : rstate_t;
  signal arid : std_ulogic_vector(axi_slave_arid'range);
  signal raddr : std_ulogic_vector(3 downto 0);
  signal raddr_en : std_ulogic;
  signal rdata : std_ulogic_vector(axi_slave_rdata'range);
  signal rdata_en : std_ulogic;
begin

waddr <= axi_slave_awaddr(3 downto 0) when waddr_en = '1' and rising_edge(clk);
awid  <= axi_slave_awid  when waddr_en = '1' and rising_edge(clk);
wdata <= axi_slave_wdata when wdata_en = '1' and rising_edge(clk);
reg <= x"affe1234" when rst_n = '0' else wdata when reg_en = '1' and rising_edge(clk);
axi_slave_bresp <= "00"; -- o.k.
axi_slave_bid <= awid;

w_proc : process(cwstate, axi_slave_awvalid, axi_slave_wvalid, axi_slave_bready)
begin
  axi_slave_awready <= '0';
  axi_slave_wready  <= '0';
  axi_slave_bvalid  <= '0';
  reg_en <= '0';
  nwstate <= cwstate;
  waddr_en <= '0';
  wdata_en <= '0';
  case cwstate is
    when AXIW_IDLE =>
      axi_slave_awready <= '1';
      axi_slave_wready  <= '1';
      if    axi_slave_awvalid = '1' and axi_slave_wvalid = '0' then
        nwstate <= AXIW_ADDR_RECEIVED;
        waddr_en <= '1';
      elsif axi_slave_awvalid = '0' and axi_slave_wvalid = '1' then
        nwstate <= AXIW_DATA_RECEIVED;
        wdata_en <= '1';
      elsif axi_slave_awvalid = '1' and axi_slave_wvalid = '1' then
        nwstate <= AXIW_RESPONSE;
        waddr_en <= '1';
        wdata_en <= '1';
      end if;
    when AXIW_ADDR_RECEIVED =>
      axi_slave_wready <= '1';
      if axi_slave_wvalid = '1' then
        wdata_en <= '1';
        nwstate <= AXIW_RESPONSE;
      end if;
    when AXIW_DATA_RECEIVED =>
      axi_slave_awready <= '1';
      if axi_slave_awvalid = '1' then
        waddr_en <= '1';
        nwstate <= AXIW_RESPONSE;
      end if;
    when AXIW_RESPONSE =>
      axi_slave_bvalid <= '1';
      reg_en <= '1';
      if axi_slave_bready = '1' then
        nwstate <= AXIW_IDLE;
      else
        nwstate <= AXIW_RESPONSE_WAIT;
      end if;
    when AXIW_RESPONSE_WAIT =>
      axi_slave_bvalid <= '1';
      if axi_slave_bready = '1' then
        nwstate <= AXIW_IDLE;
      end if;
    when others =>
  end case;
end process;

cwstate <= AXIW_IDLE when rst_n = '0' else nwstate when rising_edge(clk);
---------------------
-- Read processing
---------------------
axi_slave_rresp <= "00"; -- o.k.
axi_slave_rlast <= '1';
axi_slave_rid <= arid;
axi_slave_rlast <= '1';
axi_slave_rdata <= rdata;
rdata <= reg when rdata_en = '1' and rising_edge(clk);
arid  <= axi_slave_arid   when raddr_en = '1' and rising_edge(clk);
raddr <= axi_slave_araddr(3 downto 0) when raddr_en = '1' and rising_edge(clk);

r_proc : process(crstate, axi_slave_arvalid, axi_slave_rready)
begin
  axi_slave_arready <= '0';
  axi_slave_rvalid  <= '0';
  nrstate <= crstate;
  rdata_en <= '0';
  raddr_en <= '0';
  case crstate is
    when AXIR_IDLE =>
      axi_slave_arready <= '1';
      if axi_slave_arvalid = '1' then
        rdata_en <= '1';
        raddr_en <= '1';
        nrstate <= AXIR_RESPONSE;
      end if;
    when AXIR_RESPONSE =>
      axi_slave_rvalid <= '1';
      if axi_slave_rready = '1' then
        nrstate <= AXIR_IDLE;
      end if;
    when others =>
  end case;
end process;

crstate <= AXIR_IDLE when rst_n = '0' else nrstate when rising_edge(clk);

led_o <= reg(9 downto 0);

end;

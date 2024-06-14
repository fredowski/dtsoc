-- #############################################################################
-- DE1_SoC_top_level.vhd
-- =====================
--
-- BOARD : DE1-SoC from Terasic
-- Author : Sahand Kashani-Akhavan from Terasic documentation
-- Revision : 1.7
-- Last updated : 2017-06-11 12:48:26 UTC
--
-- Syntax Rule : GROUP_NAME_N[bit]
--
-- GROUP  : specify a particular interface (ex: SDR_)
-- NAME   : signal name (ex: CONFIG, D, ...)
-- bit    : signal index
-- _N     : to specify an active-low signal
-- #############################################################################

library ieee;
use ieee.std_logic_1164.all;

entity DE1_SoC_top is
port(
  -- ADC
  ADC_CS_n : out std_logic;
  ADC_DIN  : out std_logic;
  ADC_DOUT : in  std_logic;
  ADC_SCLK : out std_logic;

  -- Audio
  AUD_ADCDAT  : in    std_logic;
  AUD_ADCLRCK : inout std_logic;
  AUD_BCLK    : inout std_logic;
  AUD_DACDAT  : out   std_logic;
  AUD_DACLRCK : inout std_logic;
  AUD_XCK     : out   std_logic;

  -- CLOCK
  CLOCK_50  : in std_logic;
  CLOCK2_50 : in std_logic;
  CLOCK3_50 : in std_logic;
  CLOCK4_50 : in std_logic;

  -- SDRAM
  DRAM_ADDR  : out   std_logic_vector(12 downto 0);
  DRAM_BA    : out   std_logic_vector(1 downto 0);
  DRAM_CAS_N : out   std_logic;
  DRAM_CKE   : out   std_logic;
  DRAM_CLK   : out   std_logic;
  DRAM_CS_N  : out   std_logic;
  DRAM_DQ    : inout std_logic_vector(15 downto 0);
  DRAM_LDQM  : out   std_logic;
  DRAM_RAS_N : out   std_logic;
  DRAM_UDQM  : out   std_logic;
  DRAM_WE_N  : out   std_logic;

  -- I2C for Audio and Video-In
  FPGA_I2C_SCLK : out   std_logic;
  FPGA_I2C_SDAT : inout std_logic;

  -- SEG7
  HEX0_N : out std_logic_vector(6 downto 0);
  HEX1_N : out std_logic_vector(6 downto 0);
  HEX2_N : out std_logic_vector(6 downto 0);
  HEX3_N : out std_logic_vector(6 downto 0);
  HEX4_N : out std_logic_vector(6 downto 0);
  HEX5_N : out std_logic_vector(6 downto 0);

  -- IR
  IRDA_RXD : in  std_logic;
  IRDA_TXD : out std_logic;

  -- KEY_N
  KEY_N : in std_logic_vector(3 downto 0);

  -- LED
  LEDR : out std_ulogic_vector(9 downto 0);

  -- PS2
  PS2_CLK  : inout std_logic;
  PS2_CLK2 : inout std_logic;
  PS2_DAT  : inout std_logic;
  PS2_DAT2 : inout std_logic;

  -- SW
  SW : in std_logic_vector(9 downto 0);

  -- Video-In
  TD_CLK27   : inout std_logic;
  TD_DATA    : out   std_logic_vector(7 downto 0);
  TD_HS      : out   std_logic;
  TD_RESET_N : out   std_logic;
  TD_VS      : out   std_logic;

  -- VGA
  VGA_B       : out std_logic_vector(7 downto 0);
  VGA_BLANK_N : out std_logic;
  VGA_CLK     : out std_logic;
  VGA_G       : out std_logic_vector(7 downto 0);
  VGA_HS      : out std_logic;
  VGA_R       : out std_logic_vector(7 downto 0);
  VGA_SYNC_N  : out std_logic;
  VGA_VS      : out std_logic;

  -- GPIO_0
  GPIO_0 : inout std_logic_vector(35 downto 0);

  -- GPIO_1
  GPIO_1 : inout std_logic_vector(35 downto 0);

  -- HPS
  HPS_CONV_USB_N   : inout std_logic;
  HPS_DDR3_ADDR    : out   std_logic_vector(14 downto 0);
  HPS_DDR3_BA      : out   std_logic_vector(2 downto 0);
  HPS_DDR3_CAS_N   : out   std_logic;
  HPS_DDR3_CK_N    : out   std_logic;
  HPS_DDR3_CK_P    : out   std_logic;
  HPS_DDR3_CKE     : out   std_logic;
  HPS_DDR3_CS_N    : out   std_logic;
  HPS_DDR3_DM      : out   std_logic_vector(3 downto 0);
  HPS_DDR3_DQ      : inout std_logic_vector(31 downto 0);
  HPS_DDR3_DQS_N   : inout std_logic_vector(3 downto 0);
  HPS_DDR3_DQS_P   : inout std_logic_vector(3 downto 0);
  HPS_DDR3_ODT     : out   std_logic;
  HPS_DDR3_RAS_N   : out   std_logic;
  HPS_DDR3_RESET_N : out   std_logic;
  HPS_DDR3_RZQ     : in    std_logic;
  HPS_DDR3_WE_N    : out   std_logic;
  HPS_ENET_GTX_CLK : out   std_logic;
  HPS_ENET_INT_N   : inout std_logic;
  HPS_ENET_MDC     : out   std_logic;
  HPS_ENET_MDIO    : inout std_logic;
  HPS_ENET_RX_CLK  : in    std_logic;
  HPS_ENET_RX_DATA : in    std_logic_vector(3 downto 0);
  HPS_ENET_RX_DV   : in    std_logic;
  HPS_ENET_TX_DATA : out   std_logic_vector(3 downto 0);
  HPS_ENET_TX_EN   : out   std_logic;
  HPS_FLASH_DATA   : inout std_logic_vector(3 downto 0);
  HPS_FLASH_DCLK   : out   std_logic;
  HPS_FLASH_NCSO   : out   std_logic;
  HPS_GSENSOR_INT  : inout std_logic;
  HPS_I2C_CONTROL  : inout std_logic;
  HPS_I2C1_SCLK    : inout std_logic;
  HPS_I2C1_SDAT    : inout std_logic;
  HPS_I2C2_SCLK    : inout std_logic;
  HPS_I2C2_SDAT    : inout std_logic;
  HPS_KEY_N        : inout std_logic;
  HPS_LED          : inout std_logic;
  HPS_LTC_GPIO     : inout std_logic;
  HPS_SD_CLK       : out   std_logic;
  HPS_SD_CMD       : inout std_logic;
  HPS_SD_DATA      : inout std_logic_vector(3 downto 0);
  HPS_SPIM_CLK     : out   std_logic;
  HPS_SPIM_MISO    : in    std_logic;
  HPS_SPIM_MOSI    : out   std_logic;
  HPS_SPIM_SS      : inout std_logic;
  HPS_UART_RX      : in    std_logic;
  HPS_UART_TX      : out   std_logic;
  HPS_USB_CLKOUT   : in    std_logic;
  HPS_USB_DATA     : inout std_logic_vector(7 downto 0);
  HPS_USB_DIR      : in    std_logic;
  HPS_USB_NXT      : in    std_logic;
  HPS_USB_STP      : out   std_logic
);
end entity DE1_SoC_top;

architecture rtl of DE1_SoC_top is
	component de1_soc is
		port (
			clk_clk                         : in    std_logic                     := 'X';             -- clk
			hps_0_h2f_lw_axi_clock_clk      : in    std_logic                     := 'X';             -- clk
			hps_0_h2f_lw_axi_master_awid    : out   std_logic_vector(11 downto 0);                    -- awid
			hps_0_h2f_lw_axi_master_awaddr  : out   std_logic_vector(20 downto 0);                    -- awaddr
			hps_0_h2f_lw_axi_master_awlen   : out   std_logic_vector(3 downto 0);                     -- awlen
			hps_0_h2f_lw_axi_master_awsize  : out   std_logic_vector(2 downto 0);                     -- awsize
			hps_0_h2f_lw_axi_master_awburst : out   std_logic_vector(1 downto 0);                     -- awburst
			hps_0_h2f_lw_axi_master_awlock  : out   std_logic_vector(1 downto 0);                     -- awlock
			hps_0_h2f_lw_axi_master_awcache : out   std_logic_vector(3 downto 0);                     -- awcache
			hps_0_h2f_lw_axi_master_awprot  : out   std_logic_vector(2 downto 0);                     -- awprot
			hps_0_h2f_lw_axi_master_awvalid : out   std_logic;                                        -- awvalid
			hps_0_h2f_lw_axi_master_awready : in    std_logic                     := 'X';             -- awready
			hps_0_h2f_lw_axi_master_wid     : out   std_logic_vector(11 downto 0);                    -- wid
			hps_0_h2f_lw_axi_master_wdata   : out   std_logic_vector(31 downto 0);                    -- wdata
			hps_0_h2f_lw_axi_master_wstrb   : out   std_logic_vector(3 downto 0);                     -- wstrb
			hps_0_h2f_lw_axi_master_wlast   : out   std_logic;                                        -- wlast
			hps_0_h2f_lw_axi_master_wvalid  : out   std_logic;                                        -- wvalid
			hps_0_h2f_lw_axi_master_wready  : in    std_logic                     := 'X';             -- wready
			hps_0_h2f_lw_axi_master_bid     : in    std_logic_vector(11 downto 0) := (others => 'X'); -- bid
			hps_0_h2f_lw_axi_master_bresp   : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- bresp
			hps_0_h2f_lw_axi_master_bvalid  : in    std_logic                     := 'X';             -- bvalid
			hps_0_h2f_lw_axi_master_bready  : out   std_logic;                                        -- bready
			hps_0_h2f_lw_axi_master_arid    : out   std_logic_vector(11 downto 0);                    -- arid
			hps_0_h2f_lw_axi_master_araddr  : out   std_logic_vector(20 downto 0);                    -- araddr
			hps_0_h2f_lw_axi_master_arlen   : out   std_logic_vector(3 downto 0);                     -- arlen
			hps_0_h2f_lw_axi_master_arsize  : out   std_logic_vector(2 downto 0);                     -- arsize
			hps_0_h2f_lw_axi_master_arburst : out   std_logic_vector(1 downto 0);                     -- arburst
			hps_0_h2f_lw_axi_master_arlock  : out   std_logic_vector(1 downto 0);                     -- arlock
			hps_0_h2f_lw_axi_master_arcache : out   std_logic_vector(3 downto 0);                     -- arcache
			hps_0_h2f_lw_axi_master_arprot  : out   std_logic_vector(2 downto 0);                     -- arprot
			hps_0_h2f_lw_axi_master_arvalid : out   std_logic;                                        -- arvalid
			hps_0_h2f_lw_axi_master_arready : in    std_logic                     := 'X';             -- arready
			hps_0_h2f_lw_axi_master_rid     : in    std_logic_vector(11 downto 0) := (others => 'X'); -- rid
			hps_0_h2f_lw_axi_master_rdata   : in    std_logic_vector(31 downto 0) := (others => 'X'); -- rdata
			hps_0_h2f_lw_axi_master_rresp   : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- rresp
			hps_0_h2f_lw_axi_master_rlast   : in    std_logic                     := 'X';             -- rlast
			hps_0_h2f_lw_axi_master_rvalid  : in    std_logic                     := 'X';             -- rvalid
			hps_0_h2f_lw_axi_master_rready  : out   std_logic;                                        -- rready
			hps_0_h2f_reset_reset_n         : out   std_logic;                                        -- reset_n
			hps_ddr3_mem_a                  : out   std_logic_vector(14 downto 0);                    -- mem_a
			hps_ddr3_mem_ba                 : out   std_logic_vector(2 downto 0);                     -- mem_ba
			hps_ddr3_mem_ck                 : out   std_logic;                                        -- mem_ck
			hps_ddr3_mem_ck_n               : out   std_logic;                                        -- mem_ck_n
			hps_ddr3_mem_cke                : out   std_logic;                                        -- mem_cke
			hps_ddr3_mem_cs_n               : out   std_logic;                                        -- mem_cs_n
			hps_ddr3_mem_ras_n              : out   std_logic;                                        -- mem_ras_n
			hps_ddr3_mem_cas_n              : out   std_logic;                                        -- mem_cas_n
			hps_ddr3_mem_we_n               : out   std_logic;                                        -- mem_we_n
			hps_ddr3_mem_reset_n            : out   std_logic;                                        -- mem_reset_n
			hps_ddr3_mem_dq                 : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			hps_ddr3_mem_dqs                : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			hps_ddr3_mem_dqs_n              : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			hps_ddr3_mem_odt                : out   std_logic;                                        -- mem_odt
			hps_ddr3_mem_dm                 : out   std_logic_vector(3 downto 0);                     -- mem_dm
			hps_ddr3_oct_rzqin              : in    std_logic                     := 'X';             -- oct_rzqin
			hps_io_hps_io_emac1_inst_TX_CLK : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0   : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1   : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2   : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3   : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_MDIO   : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC    : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_emac1_inst_RXD1   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_io_hps_io_qspi_inst_IO0     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO0
			hps_io_hps_io_qspi_inst_IO1     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO1
			hps_io_hps_io_qspi_inst_IO2     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO2
			hps_io_hps_io_qspi_inst_IO3     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO3
			hps_io_hps_io_qspi_inst_SS0     : out   std_logic;                                        -- hps_io_qspi_inst_SS0
			hps_io_hps_io_qspi_inst_CLK     : out   std_logic;                                        -- hps_io_qspi_inst_CLK
			hps_io_hps_io_sdio_inst_CMD     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK     : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP     : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_io_hps_io_spim1_inst_CLK    : out   std_logic;                                        -- hps_io_spim1_inst_CLK
			hps_io_hps_io_spim1_inst_MOSI   : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
			hps_io_hps_io_spim1_inst_MISO   : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
			hps_io_hps_io_spim1_inst_SS0    : out   std_logic;                                        -- hps_io_spim1_inst_SS0
			hps_io_hps_io_uart0_inst_RX     : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX     : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_io_hps_io_gpio_inst_GPIO09  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO35  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_io_hps_io_gpio_inst_GPIO40  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
			hps_io_hps_io_gpio_inst_GPIO48  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO53  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_io_hps_io_gpio_inst_GPIO54  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			hps_io_hps_io_gpio_inst_GPIO61  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
			reset_reset_n                   : in    std_logic                     := 'X'              -- reset_n
		);
	end component de1_soc;

  signal h2f_lw_axi_awid    : std_logic_vector(11 downto 0);
  signal h2f_lw_axi_awaddr  : std_logic_vector(20 downto 0);
  signal h2f_lw_axi_awlen   : std_logic_vector(3 downto 0);
  signal h2f_lw_axi_awsize  : std_logic_vector(2 downto 0);
  signal h2f_lw_axi_awburst : std_logic_vector(1 downto 0);
  signal h2f_lw_axi_awlock  : std_logic_vector(1 downto 0);
  signal h2f_lw_axi_awcache : std_logic_vector(3 downto 0);
  signal h2f_lw_axi_awprot  : std_logic_vector(2 downto 0);
  signal h2f_lw_axi_awvalid : std_ulogic;
  signal h2f_lw_axi_awready : std_ulogic;
  signal h2f_lw_axi_wid     : std_logic_vector(11 downto 0);
  signal h2f_lw_axi_wdata   : std_logic_vector(31 downto 0);
  signal h2f_lw_axi_wstrb   : std_logic_vector(3 downto 0);
  signal h2f_lw_axi_wlast   : std_ulogic;
  signal h2f_lw_axi_wvalid  : std_ulogic;
  signal h2f_lw_axi_wready  : std_ulogic;
  signal h2f_lw_axi_bid     : std_ulogic_vector(11 downto 0);
  signal h2f_lw_axi_bresp   : std_ulogic_vector(1 downto 0);
  signal h2f_lw_axi_bvalid  : std_ulogic;
  signal h2f_lw_axi_bready  : std_ulogic;
  signal h2f_lw_axi_arid    : std_logic_vector(11 downto 0);
  signal h2f_lw_axi_araddr  : std_logic_vector(20 downto 0);
  signal h2f_lw_axi_arlen   : std_logic_vector(3 downto 0);
  signal h2f_lw_axi_arsize  : std_logic_vector(2 downto 0);
  signal h2f_lw_axi_arburst : std_logic_vector(1 downto 0);
  signal h2f_lw_axi_arlock  : std_logic_vector(1 downto 0);
  signal h2f_lw_axi_arcache : std_logic_vector(3 downto 0);
  signal h2f_lw_axi_arprot  : std_logic_vector(2 downto 0);
  signal h2f_lw_axi_arvalid : std_ulogic;
  signal h2f_lw_axi_arready : std_ulogic;
  signal h2f_lw_axi_rdata   : std_ulogic_vector(31 downto 0);
  signal h2f_lw_axi_rid     : std_ulogic_vector(11 downto 0);
  signal h2f_lw_axi_rresp   : std_ulogic_vector(1 downto 0);
  signal h2f_lw_axi_rlast   : std_ulogic;
  signal h2f_lw_axi_rvalid  : std_ulogic;
  signal h2f_lw_axi_rready  : std_ulogic;
  signal hps_reset_n        : std_ulogic;
begin

  de1_soc_inst: de1_soc
   port map(
      clk_clk => CLOCK_50,
      hps_0_h2f_lw_axi_clock_clk      => CLOCK_50,
      hps_0_h2f_lw_axi_master_awid    => h2f_lw_axi_awid,
      hps_0_h2f_lw_axi_master_awaddr  => h2f_lw_axi_awaddr,
      hps_0_h2f_lw_axi_master_awlen   => h2f_lw_axi_awlen,
      hps_0_h2f_lw_axi_master_awsize  => h2f_lw_axi_awsize,
      hps_0_h2f_lw_axi_master_awburst => h2f_lw_axi_awburst,
      hps_0_h2f_lw_axi_master_awlock  => h2f_lw_axi_awlock,
      hps_0_h2f_lw_axi_master_awcache => h2f_lw_axi_awcache,
      hps_0_h2f_lw_axi_master_awprot  => h2f_lw_axi_awprot,
      hps_0_h2f_lw_axi_master_awvalid => h2f_lw_axi_awvalid,
      hps_0_h2f_lw_axi_master_awready => h2f_lw_axi_awready,
      hps_0_h2f_lw_axi_master_wid     => h2f_lw_axi_wid,
      hps_0_h2f_lw_axi_master_wdata   => h2f_lw_axi_wdata,
      hps_0_h2f_lw_axi_master_wstrb   => h2f_lw_axi_wstrb,
      hps_0_h2f_lw_axi_master_wlast   => h2f_lw_axi_wlast,
      hps_0_h2f_lw_axi_master_wvalid  => h2f_lw_axi_wvalid,
      hps_0_h2f_lw_axi_master_wready  => h2f_lw_axi_wready,
      hps_0_h2f_lw_axi_master_bid     => std_logic_vector(h2f_lw_axi_bid),
      hps_0_h2f_lw_axi_master_bresp   => std_logic_vector(h2f_lw_axi_bresp),
      hps_0_h2f_lw_axi_master_bvalid  => h2f_lw_axi_bvalid,
      hps_0_h2f_lw_axi_master_bready  => h2f_lw_axi_bready,
      hps_0_h2f_lw_axi_master_arid    => h2f_lw_axi_arid,
      hps_0_h2f_lw_axi_master_araddr  => h2f_lw_axi_araddr,
      hps_0_h2f_lw_axi_master_arlen   => h2f_lw_axi_arlen,
      hps_0_h2f_lw_axi_master_arsize  => h2f_lw_axi_arsize,
      hps_0_h2f_lw_axi_master_arburst => h2f_lw_axi_arburst,
      hps_0_h2f_lw_axi_master_arlock  => h2f_lw_axi_arlock,
      hps_0_h2f_lw_axi_master_arcache => h2f_lw_axi_arcache,
      hps_0_h2f_lw_axi_master_arprot  => h2f_lw_axi_arprot,
      hps_0_h2f_lw_axi_master_arvalid => h2f_lw_axi_arvalid,
      hps_0_h2f_lw_axi_master_arready => h2f_lw_axi_arready,
      hps_0_h2f_lw_axi_master_rid     => std_logic_vector(h2f_lw_axi_rid),
      hps_0_h2f_lw_axi_master_rdata   => std_logic_vector(h2f_lw_axi_rdata),
      hps_0_h2f_lw_axi_master_rresp   => std_logic_vector(h2f_lw_axi_rresp),
      hps_0_h2f_lw_axi_master_rlast   => h2f_lw_axi_rlast,
      hps_0_h2f_lw_axi_master_rvalid  => h2f_lw_axi_rvalid,
      hps_0_h2f_lw_axi_master_rready  => h2f_lw_axi_rready,
      hps_0_h2f_reset_reset_n         => hps_reset_n,
      hps_ddr3_mem_a => HPS_DDR3_ADDR,
      hps_ddr3_mem_ba => HPS_DDR3_BA,
      hps_ddr3_mem_ck => HPS_DDR3_CK_P,
      hps_ddr3_mem_ck_n => HPS_DDR3_CK_N,
      hps_ddr3_mem_cke => HPS_DDR3_CKE,
      hps_ddr3_mem_cs_n => HPS_DDR3_CS_N,
      hps_ddr3_mem_ras_n => HPS_DDR3_RAS_N,
      hps_ddr3_mem_cas_n => HPS_DDR3_CAS_N,
      hps_ddr3_mem_we_n => HPS_DDR3_WE_N,
      hps_ddr3_mem_reset_n => HPS_DDR3_RESET_N,
      hps_ddr3_mem_dq => HPS_DDR3_DQ,
      hps_ddr3_mem_dqs => HPS_DDR3_DQS_P,
      hps_ddr3_mem_dqs_n => HPS_DDR3_DQS_N,
      hps_ddr3_mem_odt => HPS_DDR3_ODT,
      hps_ddr3_mem_dm => HPS_DDR3_DM,
      hps_ddr3_oct_rzqin => HPS_DDR3_RZQ,
      hps_io_hps_io_emac1_inst_TX_CLK => HPS_ENET_GTX_CLK,
      hps_io_hps_io_emac1_inst_TXD0 => HPS_ENET_TX_DATA(0),
      hps_io_hps_io_emac1_inst_TXD1 => HPS_ENET_TX_DATA(1),
      hps_io_hps_io_emac1_inst_TXD2 => HPS_ENET_TX_DATA(2),
      hps_io_hps_io_emac1_inst_TXD3 => HPS_ENET_TX_DATA(3),
      hps_io_hps_io_emac1_inst_RXD0 => HPS_ENET_RX_DATA(0),
      hps_io_hps_io_emac1_inst_MDIO => HPS_ENET_MDIO,
      hps_io_hps_io_emac1_inst_MDC => HPS_ENET_MDC,
      hps_io_hps_io_emac1_inst_RX_CTL => HPS_ENET_RX_DV,
      hps_io_hps_io_emac1_inst_TX_CTL => HPS_ENET_TX_EN,
      hps_io_hps_io_emac1_inst_RX_CLK => HPS_ENET_RX_CLK,
      hps_io_hps_io_emac1_inst_RXD1 => HPS_ENET_RX_DATA(1),
      hps_io_hps_io_emac1_inst_RXD2 => HPS_ENET_RX_DATA(2),
      hps_io_hps_io_emac1_inst_RXD3 => HPS_ENET_RX_DATA(3),
      hps_io_hps_io_qspi_inst_IO0 => HPS_FLASH_DATA(0),
      hps_io_hps_io_qspi_inst_IO1 => HPS_FLASH_DATA(1),
      hps_io_hps_io_qspi_inst_IO2 => HPS_FLASH_DATA(2),
      hps_io_hps_io_qspi_inst_IO3 => HPS_FLASH_DATA(3),
      hps_io_hps_io_qspi_inst_SS0 => HPS_FLASH_NCSO,
      hps_io_hps_io_qspi_inst_CLK => HPS_FLASH_DCLK,
      hps_io_hps_io_sdio_inst_CMD => HPS_SD_CMD,
      hps_io_hps_io_sdio_inst_D0 => HPS_SD_DATA(0),
      hps_io_hps_io_sdio_inst_D1 => HPS_SD_DATA(1),
      hps_io_hps_io_sdio_inst_CLK => HPS_SD_CLK,
      hps_io_hps_io_sdio_inst_D2 => HPS_SD_DATA(2),
      hps_io_hps_io_sdio_inst_D3 => HPS_SD_DATA(3),
      hps_io_hps_io_usb1_inst_D0 => HPS_USB_DATA(0),
      hps_io_hps_io_usb1_inst_D1 => HPS_USB_DATA(1),
      hps_io_hps_io_usb1_inst_D2 => HPS_USB_DATA(2),
      hps_io_hps_io_usb1_inst_D3 => HPS_USB_DATA(3),
      hps_io_hps_io_usb1_inst_D4 => HPS_USB_DATA(4),
      hps_io_hps_io_usb1_inst_D5 => HPS_USB_DATA(5),
      hps_io_hps_io_usb1_inst_D6 => HPS_USB_DATA(6),
      hps_io_hps_io_usb1_inst_D7 => HPS_USB_DATA(7),
      hps_io_hps_io_usb1_inst_CLK => HPS_USB_CLKOUT,
      hps_io_hps_io_usb1_inst_STP => HPS_USB_STP,
      hps_io_hps_io_usb1_inst_DIR => HPS_USB_DIR,
      hps_io_hps_io_usb1_inst_NXT => HPS_USB_NXT,
      hps_io_hps_io_spim1_inst_CLK => HPS_SPIM_CLK,
      hps_io_hps_io_spim1_inst_MOSI => HPS_SPIM_MOSI,
      hps_io_hps_io_spim1_inst_MISO => HPS_SPIM_MISO,
      hps_io_hps_io_spim1_inst_SS0 => HPS_SPIM_SS,
      hps_io_hps_io_uart0_inst_RX => HPS_UART_RX,
      hps_io_hps_io_uart0_inst_TX => HPS_UART_TX,
      hps_io_hps_io_i2c0_inst_SDA => HPS_I2C1_SDAT,
      hps_io_hps_io_i2c0_inst_SCL => HPS_I2C1_SCLK,
      hps_io_hps_io_i2c1_inst_SDA => HPS_I2C2_SDAT,
      hps_io_hps_io_i2c1_inst_SCL => HPS_I2C2_SCLK,
      hps_io_hps_io_gpio_inst_GPIO09 => HPS_CONV_USB_N,
      hps_io_hps_io_gpio_inst_GPIO35 => HPS_ENET_INT_N,
      hps_io_hps_io_gpio_inst_GPIO40 => HPS_LTC_GPIO,
      hps_io_hps_io_gpio_inst_GPIO48 => HPS_I2C_CONTROL,
      hps_io_hps_io_gpio_inst_GPIO53 => HPS_LED,
      hps_io_hps_io_gpio_inst_GPIO54 => HPS_KEY_N,
      hps_io_hps_io_gpio_inst_GPIO61 => HPS_GSENSOR_INT,
      reset_reset_n => hps_reset_n
  );

  axireg_inst: entity work.axireg
   port map(
      clk => CLOCK_50,
      rst_n => hps_reset_n,
      axi_slave_awid    => std_ulogic_vector(h2f_lw_axi_awid),
      axi_slave_awaddr  => std_ulogic_vector(h2f_lw_axi_awaddr),
      axi_slave_awlen   => std_ulogic_vector(h2f_lw_axi_awlen),
      axi_slave_awsize  => std_ulogic_vector(h2f_lw_axi_awsize),
      axi_slave_awburst => std_ulogic_vector(h2f_lw_axi_awburst),
      axi_slave_awlock  => std_ulogic_vector(h2f_lw_axi_awlock),
      axi_slave_awcache => std_ulogic_vector(h2f_lw_axi_awcache),
      axi_slave_awprot  => std_ulogic_vector(h2f_lw_axi_awprot),
      axi_slave_awvalid => h2f_lw_axi_awvalid,
      axi_slave_awready => h2f_lw_axi_awready,
      axi_slave_wid     => std_ulogic_vector(h2f_lw_axi_wid),
      axi_slave_wdata   => std_ulogic_vector(h2f_lw_axi_wdata),
      axi_slave_wstrb   => std_ulogic_vector(h2f_lw_axi_wstrb),
      axi_slave_wlast   => h2f_lw_axi_wlast,
      axi_slave_wvalid  => h2f_lw_axi_wvalid,
      axi_slave_wready  => h2f_lw_axi_wready,
      axi_slave_bid     => h2f_lw_axi_bid,
      axi_slave_bresp   => h2f_lw_axi_bresp,
      axi_slave_bvalid  => h2f_lw_axi_bvalid,
      axi_slave_bready  => h2f_lw_axi_bready,
      axi_slave_arid    => std_ulogic_vector(h2f_lw_axi_arid),
      axi_slave_araddr  => std_ulogic_vector(h2f_lw_axi_araddr),
      axi_slave_arlen   => std_ulogic_vector(h2f_lw_axi_arlen),
      axi_slave_arsize  => std_ulogic_vector(h2f_lw_axi_arsize),
      axi_slave_arburst => std_ulogic_vector(h2f_lw_axi_arburst),
      axi_slave_arlock  => std_ulogic_vector(h2f_lw_axi_arlock),
      axi_slave_arcache => std_ulogic_vector(h2f_lw_axi_arcache),
      axi_slave_arprot  => std_ulogic_vector(h2f_lw_axi_arprot),
      axi_slave_arvalid => h2f_lw_axi_arvalid,
      axi_slave_arready => h2f_lw_axi_arready,
      axi_slave_rid     => h2f_lw_axi_rid,
      axi_slave_rdata   => h2f_lw_axi_rdata,
      axi_slave_rresp   => h2f_lw_axi_rresp,
      axi_slave_rlast   => h2f_lw_axi_rlast,
      axi_slave_rvalid  => h2f_lw_axi_rvalid,
      axi_slave_rready  => h2f_lw_axi_rready,
      led_o             => LEDR
  );

end;

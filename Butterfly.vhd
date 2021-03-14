library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Butterfly is 

	generic (
		width : positive := 16);
	port (
		clk	 		  : in std_logic;
		rst 	 		  : in std_logic;
		
		twiddle_real  : in std_logic_vector(width-1 downto 0);
		twiddle_img   : in std_logic_vector(width-1 downto 0);
		
		input_1_real  : in std_logic_vector(width-1 downto 0);
		input_1_img   : in std_logic_vector(width-1 downto 0);
		input_2_real  : in std_logic_vector(width-1 downto 0);
		input_2_img   : in std_logic_vector(width-1 downto 0);
		
		output_1_real  : out std_logic_vector(width-1 downto 0);
		output_1_img   : out std_logic_vector(width-1 downto 0);
		output_2_real  : out std_logic_vector(width-1 downto 0);
		output_2_img   : out std_logic_vector(width-1 downto 0)
		);

end Butterfly;

architecture bf of Butterfly is

	component complex_mult --when swapping  
		port (
			dataa_real  : in  std_logic_vector(15 downto 0) := (others => '0'); 
			dataa_imag  : in  std_logic_vector(15 downto 0) := (others => '0'); 
			datab_real  : in  std_logic_vector(15 downto 0) := (others => '0'); 
			datab_imag  : in  std_logic_vector(15 downto 0) := (others => '0'); 
			result_real : out std_logic_vector(31 downto 0);                    
			result_imag : out std_logic_vector(31 downto 0);                   
			clock       : in  std_logic                     := '0'            
		);
	end component;
	
	signal mult_out_real, mult_out_img : std_logic_vector((width*2) - 1 downto 0);	
	signal dbuffer_out_real, dbuffer_out_img : std_logic_vector(width-1 downto 0);
	
begin 

	mult : complex_mult -- how to specify library here? which lib is this in?
		port map (
			dataa_real  => input_2_real,
			dataa_imag  => input_2_img,
			datab_real  => twiddle_real,
			datab_imag  => twiddle_img,
			result_real => mult_out_real,                 
			result_imag => mult_out_img,                 
			clock       => clk);
	
	add1 : entity work.complex_add
		generic map (width => width)
		port map (
			clk => clk,
			rst => rst,
		
			r1_in => dbuffer_out_real,
			i1_in => dbuffer_out_img,
			r2_in => mult_out_real((width*2) - 1 downto width),
			i2_in => mult_out_img((width*2) - 1 downto width),

			r_out => output_1_real,
			i_out => output_1_img);
			
	add2 : entity work.complex_add
		generic map (width => width)
		port map (
			clk => clk,
			rst => rst,
		
			r1_in => dbuffer_out_real,
			i1_in => dbuffer_out_img,
			r2_in => std_logic_vector(resize(-1*signed(mult_out_real((width*2) - 1 downto width)), width)),
			i2_in => std_logic_vector(resize(-1*signed(mult_out_img((width*2) - 1 downto width)), width)),

			r_out => output_2_real,
			i_out => output_2_img);
	
	delay_buffer : entity work.pipe_reg
		generic map (length => 4,
						 width => width)
		port map (
			clk => clk,
			rst => rst,
			input_real => input_1_real,
			input_img => input_1_img,
			output_real => dbuffer_out_real,
			output_img => dbuffer_out_img);	

end bf;
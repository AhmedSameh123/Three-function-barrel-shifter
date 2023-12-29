library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shifter is
 generic (
        DATA_WIDTH : integer := 8 );   
	port (
        d_in        : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);  -- input vector
        d_out       : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);  -- output vector
        shift_op    : in  std_logic_vector(0 to 1);                   -- 00=don't change,01=rotate, 10=arithmetical, 11=logical
        shift_amt   : in  STD_LOGIC_VECTOR(3 downto 0);               -- number of positions to be shifted or rotated
        direction   : in  std_logic;                                  -- '0' = right, '1' = left
        clk         : in  std_logic                                   -- Clock
    );
end entity Shifter;

architecture Behavior of Shifter is
begin
    process(clk)
    begin
      if rising_edge(clk) then
            if shift_op = "01" then  -- rotate
                if direction = '0' then  -- right
                    d_out <= std_logic_vector(rotate_right(unsigned(d_in), to_integer(unsigned(shift_amt))));
                else  -- left
                    d_out <= std_logic_vector(rotate_left(unsigned(d_in), to_integer(unsigned(shift_amt))));
                end if;
            end if;
            
            if shift_op = "10" then  -- arithmetical
                if direction = '0' then  -- right
                    d_out <= std_logic_vector(shift_right(signed(d_in), to_integer(signed(shift_amt))));
                else  -- left
                    d_out <= std_logic_vector(shift_left(signed(d_in), to_integer(signed(shift_amt))));
                end if;
            end if;
            
            if shift_op = "11" then  -- logical
                if direction = '0' then  -- right
                    d_out <= std_logic_vector(shift_right(unsigned(d_in), to_integer(unsigned(shift_amt))));
                else  -- left
                    d_out <= std_logic_vector(shift_left(unsigned(d_in), to_integer(unsigned(shift_amt))));
                end if;
            end if;
            
            if shift_op = "00" then  -- don't change
                d_out <= d_in;
            end if;
        end if;
    end process;
end Behavior;

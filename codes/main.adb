with Ada.Text_IO; use Ada.Text_IO;
with Ada.Calendar; use Ada.Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;

procedure ESC_Detection is
   ESC_Count : Natural := 0;
   Last_Key_Time : Time := Clock;
   Key : Character;

   function Get_Immediate_Key return Character is
      C : Character;
      Available : Boolean;
   begin
      Get_Immediate (C, Available);
      if Available then
         return C;
      else
         return ASCII.NUL;
      end if;
   end Get_Immediate_Key;

begin
   Put_Line ("ESCキーを8回押してください");

   loop
      Key := Get_Immediate_Key;

      if Key = ASCII.ESC then
         ESC_Count := ESC_Count + 1;
         Last_Key_Time := Clock;
         Put_Line ("ESCキーが押されました。カウント:" & ESC_Count'Image);

         if ESC_Count = 8 then
            Put_Line ("ESCキーが8回押されました");
            Put_Line ("3秒間何も押さないでください");
            delay 3.0;
            Put_Line ("3秒間経過しました");
            Put_Line ("プログラムは10分間停止します");
            delay 600.0;
            exit;
         end if;
      elsif Key /= ASCII.NUL then
         ESC_Count := 0;
      elsif Clock - Last_Key_Time > 3.0 then
         Put_Line ("3秒間キー入力がありませんでした");
         Last_Key_Time := Clock;
      end if;

      delay 0.1;
   end loop;
end ESC_Detection;
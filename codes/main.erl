-module(esc_detection).
-export([start/0]).

start() ->
    io:format("ESCキーを8回押してください~n"),
    loop(0, erlang:system_time(second)).

loop(EscCount, LastKeyTime) ->
    case io:get_line("") of
        eof ->
            io:format("プログラムを終了します~n");
        "\e" ->
            NewCount = EscCount + 1,
            io:format("ESCキーが押されました。カウント: ~p~n", [NewCount]),
            Now = erlang:system_time(second),
            if
                NewCount == 8 ->
                    io:format("ESCキーが8回押されました~n"),
                    io:format("3秒間何も押さないでください~n"),
                    timer:sleep(3000),
                    io:format("3秒間経過しました~n"),
                    io:format("プログラムは10分間停止します~n"),
                    timer:sleep(600000);
                true ->
                    loop(NewCount, Now)
            end;
        _ ->
            Now = erlang:system_time(second),
            if
                Now - LastKeyTime > 3 ->
                    io:format("3秒間キー入力がありませんでした~n"),
                    loop(0, Now);
                true ->
                    loop(0, LastKeyTime)
            end
    end.
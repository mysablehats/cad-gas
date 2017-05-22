function aaa = combineoutcomes(N)
env = aa_environment;
try
    for i = N
        outcomes(i) = load([env.allmatpath 'outcomes' env.SLASH env.currhash '-outcomes-' num2str(i)] );
    end
catch
    return
end
for i=N
    for j = outcomes(i).outcomes.idxs
        combineoutcomes(j) = outcomes(i).outcomes.b(j);
    end
end
disp(['results of hash: ' env.currhash])
aaa = analyze_outcomes(combineoutcomes)

load handel;
player = audioplayer(y, Fs);
playblocking(player);
input('')
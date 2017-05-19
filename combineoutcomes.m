function aaa = combineoutcomes
env = aa_environment;
try
    for i = 1:3
        outcomes(i) = load([env.allmatpath 'outcomes' env.SLASH env.currhash '-outcomes-' num2str(i)] );
    end
catch
    return
end
for i=1:3
    for j = outcomes(i).idxs
        combineoutcomes(j) = outcomes(i).b(j);
    end
end
disp(['results of hash: ' env.currhash])
aaa = analyze_outcomes(combineoutcomes)

load handel;
player = audioplayer(y, Fs);
playblocking(player);
input('')
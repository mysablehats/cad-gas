global wheretosavestuff SLASH
if isempty(wheretosavestuff)||isempty(SLASH)
    aa_environment
end
try
load(strcat(wheretosavestuff,SLASH,'test_skel.mat'));
catch
    load('E:\fall_detection_datasets\var_old\old\test_skel.mat')
end

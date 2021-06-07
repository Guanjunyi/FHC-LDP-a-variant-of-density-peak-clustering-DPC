function [AMI,ARI] = Evaluation(cl,answer)
import java.util.LinkedList
import Library.*
if~isempty(answer)
        AMI=GetAmi(answer,cl);
        ARI=GetAri(answer,cl);
else
    AMI=nan;
    ARI=nan;
end
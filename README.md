# FHC-LDP: Fast hierarchical clustering of local density peaks via an association degree transfer method

which is published in Neurocomputing 2021 Doi:10.1016/j.neucom.2021.05.071

In this work, we introduce a fast hierarchical clustering of local density peaks via an association degree transfer method (FHC-LDP) which first fast identifies local density peaks as sub-cluster centers to form sub-clusters and then uses a hierarchical clustering method to merge sub-clusters into final clusters optimally in global. The main contributions of this paper are:

1) FHC-LDP is a fast algorithm with a time complexity of O(nlogn) and it only calculates the KNN distance of points; 
2) we design a method to fast evaluate the similarity between sub-clusters;
3) we use a hierarchical clustering method to ensure each sub-cluster is accurately merged into its most similar cluster, which makes up for the deficiencies of DPC’s allocation strategy and center selection.

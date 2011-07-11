
#include "gsl/gsl_interp.h"
#include "stdio.h"

const gsl_interp_type* gsl_get_interp_type(int type) {
	if (type == 0)
		return gsl_interp_linear;
	else if (type == 1)
		return gsl_interp_polynomial;
	else if (type == 2)
		return gsl_interp_cspline;
	else if (type == 3)
		return gsl_interp_cspline_periodic;
	else if (type == 4)
		return gsl_interp_akima;
	else if (type == 5)
		return gsl_interp_akima_periodic;
	return NULL;
}

void gsl_debug(const double x[], int size) {
	for (int i = 0; i < size; i++)
		printf("%e\n", x[i]);
}
# %% [markdown]
# ## Get data
%load_ext autoreload
%autoreload 2
from discontinuitypy.plot.alfvenicity import tsplot_Alfvenicity
from space_analysis.ds.spz.io import to_dataarray
import speasy as spz
from speasy.core.requests_scheduling.request_dispatch import init_cdaweb
import importlib.util
import matplotlib.pyplot as plt
from beforerr.matplotlib import PlotOpts, process_figure, easy_save
import holoviews as hv

# %%
hv.extension("matplotlib")

if importlib.util.find_spec("scienceplots") is not None:
    importlib.import_module("scienceplots")
    plt.style.use(["science", "nature", "notebook"])
init_cdaweb()

# %%
plot_opts = PlotOpts(sync_legend_colors=True, hide_legend_lines=True)

# %%
coord = "gsm"
thm_products = [
    "cda/THB_L2_FGM/thb_fgs_gsm",
    "cda/THB_L2_MOM/thb_peim_velocity_gsmQ",
    "cda/THB_L2_MOM/thb_peim_densityQ",
]
thm_tr = ["2016-05-20T17:47:00", "2016-05-20T17:53:40"]

psp_products = [
    "cda/PSP_FLD_L2_MAG_RTN/psp_fld_l2_mag_RTN",
    "cda/PSP_SWP_SPI_SF00_L3_MOM/VEL_SC",
    "cda/PSP_SWP_SPI_SF00_L3_MOM/DENS",
]

# higher resolution but in `tplot` format
psp_products = [
    "psp_fld_l2_mag_RTN_4_Sa_per_Cyc",
    "psp_swp_spi_af00_L3_VEL_RTN",
    "psp_swp_spi_af00_L3_DENS",
]

psp_tr = ["2021-01-17T13:54:17", "2021-01-17T13:54:32"]

wi_products = ["cda/WI_H2_MFI/BGSE", "cda/WI_PM_3DP/P_VELS", "cda/WI_PM_3DP/P_DENS"]
wi_tr = ["2011-08-26T21:26:00", "2011-08-26T21:27:30"]

# %%
from psp.io.psp import get_data as psp_get_data


def get_data(products, timerange):
    for product in products:
        if product in psp_products:
            yield psp_get_data(product, timerange)
        else:
            d = spz.get_data(product, timerange)
            yield to_dataarray(d)


def temp(products, timerage):
    das = get_data(products, timerage)
    plot = tsplot_Alfvenicity(*das)
    for subplot in plot:
        subplot.opts(legend_position="right")
    plot[-1].opts(show_legend=False)
    return plot

# %%
configs = [(thm_products, thm_tr), (psp_products, psp_tr), (wi_products, wi_tr)]
ps = [temp(*c) for c in configs]

# %%
fig = hv.render(ps[1])

# %%
def render_p(p, name):
    p.opts(fig_size=150, tight=True, sublabel_format=None)
    fig = hv.render(p)
    fig.axes[0].legend([r"$B_x$", r"$B_y$", r"$B_z$", r"$B_{total}$"])
    fig.axes[1].legend([r"$V_x$", r"$V_y$", r"$V_z$", r"$V_{total}$"])
    fig.axes[2].legend([r"$dv_{A,x}$", r"$dU_x$"])
    process_figure(fig, plot_opts)
    easy_save(name, fig)

# %%
names = ["THB", "PSP", "Wind"]
for p, name in zip(ps, names):
    render_p(p, name)

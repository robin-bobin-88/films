<template>
    <div id="FilmListComponent" v-if="Show">        
        <el-row>
            <el-table ref="FilmTable"
                      :data="Films"
                      highlight-current-row
                      style="width: 100%;"
                      v-on:current-change="FilmTableCurrentChange">

                <el-table-column width="50">
                    <template slot-scope="scope">
                        <el-tooltip placement="top" effect="light">
                            <div slot="content" style="font-family: 'Arial';">{{ scope.row.Notice }}</div>
                            <span class="el-icon-info"></span>
                        </el-tooltip>
                    </template>
                </el-table-column>
                <el-table-column property="FilmName" label="Название"></el-table-column>
                <el-table-column property="Year" label="Год выпуска" width="140"></el-table-column>
                <el-table-column property="Country.CountryName" label="Страна" width="200"></el-table-column>
                <el-table-column property="Director.DirectorName" label="Режиссер" width="250"></el-table-column>
                <el-table-column property="Actors" label="Актеры"></el-table-column>
                <el-table-column property="Ganres" label="Жанр"></el-table-column>
            </el-table>
        </el-row>
        <el-row>
            <el-pagination layout="prev, pager, next"
                           :page-size="PageSize"
                           :pager-count="5"
                           :total="FilmCount"
                           :current-page.sync="CurrentPage"
                           v-on:current-change="PageCurrentChange">
            </el-pagination>
        </el-row>
    </div>
    </div>
</template>

<script>
    export default {
        name: "FilmListComponent",

        props: [
            "Films",
            "PageSize",
            "FilmCount",
            "CurrentPage",
            "Show"
        ],

        data() {
            return {
                
            }            
        },

        methods: {            
            FilmTableCurrentChange(val) {
                this.$emit("film-list-current-change", val);
            },

            PageCurrentChange(val) {
                this.$emit("page-current-change", val);                
            }            
        }
    }
</script>